//
//  FeedDetailViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks
import UIKit

final class FeedDetailScene<Asset: AssetProtocol>:
   BaseSceneModel<
      DefaultVCModel,
      DoubleStacksBrandedVM<Asset.Design>,
      Asset,
      (Feed, String)
   >, Scenarible
{
   typealias State = ViewState
   typealias State2 = StackState

   private lazy var feedDetailVM = FeedDetailViewModels<Design>()

   lazy var scenario: Scenario = FeedDetailScenario<Asset>(
      works: FeedDetailWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: FeedDetailEvents(
         presentDetails: feedDetailVM.filterButtons.on(\.didTapDetails),
         presentComment: feedDetailVM.filterButtons.on(\.didTapComments),
         presentReactions: feedDetailVM.filterButtons.on(\.didTapReactions),
         reactionPressed: feedDetailVM.infoBlock.on(\.reactionPressed),
         saveInput: on(\.input),
         didEditingComment: feedDetailVM.commentsBlock.commentField.on(\.didEditingChanged),
         didSendCommentPressed: feedDetailVM.commentsBlock.sendButton.on(\.didTap),
         presentAllReactions: feedDetailVM.reactionsBlock.filterButtons.on(\.didTapAll),
         presentLikeReactions: feedDetailVM.reactionsBlock.filterButtons.on(\.didTapLikes)
      )
   )

   override func start() {
      configure()
   }

   private var state = FeedDetailSceneState.initial

   private func configure() {
      vcModel?.on(\.viewDidLoad, self) {
         $0.mainVM.headerStack.arrangedModels([Spacer(8)])
         $0.mainVM.bodyStack
            .set(Design.state.stack.default)
            .alignment(.fill)
            .distribution(.fill)
            .set(.backColor(Design.color.backgroundSecondary))
            .arrangedModels([
               Spacer(32),
               $0.feedDetailVM
            ])

         guard let inputValue = $0.inputValue else { assertionFailure(); return }

         $0.feedDetailVM.setState(.initial(inputValue))
         $0.scenario.start()
      }
   }
}

enum FeedDetailSceneState {
   case initial
   case presentDetails(Feed)
   case presentComments([Comment])
   case presentReactions([ReactItem])
   case buttonLikePressed(alreadySelected: Bool)
   case failedToReact
   case updateReactions((TransactStatistics, Bool))
   case presntActivityIndicator
   case sendButtonDisabled
   case sendButtonEnabled
   case commentDidSend

   case error
}

extension FeedDetailScene: StateMachine {
   func setState(_ state: FeedDetailSceneState) {
      self.state = state
      switch state {
      case .initial:
         print("hello")
      case .presentComments(let comments):
         feedDetailVM.setState(.comments(comments))
      case .presentReactions(let items):
         feedDetailVM.setState(.reactions(items))
      case .failedToReact:
         print("failed to like")
      case .updateReactions(let value):
//         if value.1 == false {
//            likeColor = Design.color.text
//         }
         if let reactions = value.0.likes {
            for reaction in reactions {
               if reaction.likeKind?.code == "like" {
                  feedDetailVM.infoBlock.likeButton.models.right.text(String(reaction.counter ?? 0))
                  print(value.0)
                  print("like count \(reaction.counter)")
               } else if reaction.likeKind?.code == "dislike" {
//                  feedDetailVM.topBlock.dislikeButton.models.right.text(String(reaction.counter ?? 0))
               }
            }
         }
      case .presentDetails(let feed):
         feedDetailVM.setState(.details(feed))
      case .presntActivityIndicator:
         feedDetailVM.setState(.loadingActivity)
      case .sendButtonDisabled:
         feedDetailVM.setState(.sendButtonDisabled)
      case .sendButtonEnabled:
         feedDetailVM.setState(.sendButtonEnabled)
      case .commentDidSend:
         feedDetailVM.filterButtons.send(\.didTapComments)
         feedDetailVM.setState(.commentDidSend)
      case .error:
         print("Load token error")
      case .buttonLikePressed(let selected):
         if selected {
            feedDetailVM.infoBlock.likeButton.setState(.none)
         } else {
            feedDetailVM.infoBlock.likeButton.setState(.selected)
         }
      }
   }
}
