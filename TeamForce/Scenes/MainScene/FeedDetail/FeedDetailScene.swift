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
         saveInput: on(\.input)
      )
   )

   override func start() {
      configure()

      guard let inputValue else { return }

      scenario.start()

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
   case failedToReact
   case updateReactions((TransactStatistics, (Bool, Bool)))
}

extension FeedDetailScene: StateMachine {
   func setState(_ state: FeedDetailSceneState) {
      self.state = state
      switch state {
      case .initial:
         print("hello")
      case .presentComments(let comments):
         feedDetailVM.setState(.comments(comments))
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
         break
      }
   }
}
