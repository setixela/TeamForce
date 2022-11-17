//
//  FeedDetailViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks
import UIKit

enum TransactDetailsSceneInput {
   case feedElement(Feed)
   case transactId(Int)
}

final class TransactDetailsScene<Asset: AssetProtocol>:
   BaseSceneModel<
      DefaultVCModel,
      DoubleStacksBrandedVM<Asset.Design>,
      Asset,
      TransactDetailsSceneInput
   >, Scenarible
{
   typealias State = ViewState
   typealias State2 = StackState

   private lazy var feedDetailVM = FeedDetailViewModels<Asset>()

   lazy var scenario: Scenario = TransactDetailsScenario<Asset>(
      works: TransactDetailsWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: FeedDetailEvents(
         presentDetails: feedDetailVM.filterButtons.on(\.didTapDetails),
         presentComment: feedDetailVM.filterButtons.on(\.didTapComments),
         presentReactions: feedDetailVM.filterButtons.on(\.didTapReactions),
         reactionPressed: feedDetailVM.infoBlock.on(\.reactionPressed),
         userAvatarPressed: feedDetailVM.infoBlock.on(\.userAvatarPressed),
         saveInput: on(\.input),
         didEditingComment: feedDetailVM.commentsBlock.commentField.on(\.didEditingChanged),
         didSendCommentPressed: feedDetailVM.commentsBlock.sendButton.on(\.didTap),
         presentAllReactions: feedDetailVM.reactionsBlock.filterButtons.on(\.didTapAll),
         presentLikeReactions: feedDetailVM.reactionsBlock.filterButtons.on(\.didTapLikes)
      )
   )

   override func start() {
      vcModel?.on(\.viewDidLoad, self) {
         $0.configure()
      }
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

      setState(.initial)
      scenario.start()
   }
}

enum FeedDetailSceneState {
   case initial
   case present(feed: Feed, currentUsername: String)
   case presentDetails(transaction: EventTransaction, currentUsername: String)
   case presentComments([Comment])
   case presentReactions([ReactItem])
   case buttonLikePressed(alreadySelected: Bool)
   case failedToReact(alreadySelected: Bool)
   case updateReactions((LikesCommentsStatistics, Bool))
   case presntActivityIndicator
   case sendButtonDisabled
   case sendButtonEnabled
   case commentDidSend
   case hereIsEmpty
   case presentUserProfile(Int)

   case error
}

extension TransactDetailsScene: StateMachine {
   func setState(_ state: FeedDetailSceneState) {
      self.state = state
      switch state {
      case .initial:
         feedDetailVM.setState(.loadingActivity)
         //
      case .present(let feed, let userName):
         feedDetailVM.setState(.initial(feed: feed, curUsername: userName))
         //
      case .presentDetails(let transaction, let userName):
         feedDetailVM.infoBlock.setup((transaction, userName))
         feedDetailVM.setState(.details(transaction))
         //
      case .presentComments(let comments):
         feedDetailVM.setState(.comments(comments))
         //
      case .presentReactions(let items):
         feedDetailVM.setState(.reactions(items))
         //
      case .failedToReact(let selected):
         print("failed to like")
         setState(.buttonLikePressed(alreadySelected: !selected))
         //
      case .updateReactions(let value):
         if let reactions = value.0.likes {
            for reaction in reactions {
               if reaction.likeKind?.code == "like" {
                  feedDetailVM.infoBlock.likeButton.models.right.text(String(reaction.counter ?? 0))
               }
            }
         }
         //
      case .presntActivityIndicator:
         feedDetailVM.setState(.loadingActivity)
         //
      case .sendButtonDisabled:
         feedDetailVM.setState(.sendButtonDisabled)
         //
      case .sendButtonEnabled:
         feedDetailVM.setState(.sendButtonEnabled)
         //
      case .commentDidSend:
         feedDetailVM.filterButtons.send(\.didTapComments)
         feedDetailVM.setState(.commentDidSend)
         //
      case .error:
         print("Load token error")
      case .buttonLikePressed(let selected):
         if selected {
            feedDetailVM.infoBlock.likeButton.setState(.none)
         } else {
            feedDetailVM.infoBlock.likeButton.setState(.selected)
         }
         //
      case .presentUserProfile(let userId):
         Asset.router?.route(.push, scene: \.profile, payload: userId)
         //
      case .hereIsEmpty:
         feedDetailVM.setState(.hereIsEmpty)
         //
      }
   }
}
