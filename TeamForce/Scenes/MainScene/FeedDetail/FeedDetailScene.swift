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
         reactionPressed: feedDetailVM.topBlock.on(\.reactionPressed),
         saveInput: on(\.input),
         didEditingComment: feedDetailVM.commentsBlock.commentField.on(\.didEditingChanged),
         didSendCommentPressed: feedDetailVM.commentsBlock.sendButton.on(\.didTap),
         presentAllReactions: feedDetailVM.reactionsBlock.filterButtons.on(\.didTapAll),
         presentLikeReactions: feedDetailVM.reactionsBlock.filterButtons.on(\.didTapLikes),
         presentDislikeReactions: feedDetailVM.reactionsBlock.filterButtons.on(\.didTapDislikes)
      )
   )

   override func start() {
      configure()

      guard let inputValue else { return }

      feedDetailVM.setState(.initial(inputValue))
   }

   private var state = FeedDetailSceneState.initial

   private func configure() {
      mainVM.headerStack.arrangedModels([Spacer(8)])
      mainVM.bodyStack
         .set(Design.state.stack.default)
         .alignment(.fill)
         .distribution(.fill)
         .set(.backColor(Design.color.backgroundSecondary))
         .arrangedModels([
            Spacer(32),
            feedDetailVM
         ])
   }
}

enum FeedDetailSceneState {
   case initial
   case presentDetails(Feed)
   case presentComments([Comment])
   case presentReactions([ReactItem])
   case failedToReact
   case updateReactions((TransactStatistics, (Bool, Bool)))
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
         var likeColor = Design.color.activeButtonBack
         var dislikeColor = Design.color.activeButtonBack
         if value.1.0 == false {
            likeColor = Design.color.text
         }
         if value.1.1 == false {
            dislikeColor = Design.color.text
         }
         feedDetailVM.topBlock.likeButton.models.main.imageTintColor(likeColor)
         feedDetailVM.topBlock.dislikeButton.models.main.imageTintColor(dislikeColor)

         if let reactions = value.0.likes {
            for reaction in reactions {
               if reaction.likeKind?.code == "like" {
                  feedDetailVM.topBlock.likeButton.models.right.text(String(reaction.counter ?? 0))
               } else if reaction.likeKind?.code == "dislike" {
                  feedDetailVM.topBlock.dislikeButton.models.right.text(String(reaction.counter ?? 0))
               }
            }
         }
         break
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
      }
   }
}
