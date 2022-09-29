//
//  FeedDetailViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks
import UIKit

final class FeedDetailScene<Asset: AssetProtocol>: // ModalDoubleStackModel<Asset>, Eventable
   BaseSceneModel<
      DefaultVCModel,
      TripleStacksBrandedVM<Asset.Design>,
      Asset,
      (Feed, String)
   >, Scenarible
{
   typealias State = ViewState
   typealias State2 = StackState
   
   private lazy var viewModels = FeedDetailViewModels<Design>()
   
   lazy var scenario: Scenario = FeedDetailScenario<Asset>(
      works: FeedDetailWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: FeedDetailEvents(
         presentComment: viewModels.filterButtons.on(\.didTapComments),
         presentReactions: viewModels.filterButtons.on(\.didTapReactions),
         reactionPressed: viewModels.on(\.reactionPressed),
         saveInput: viewModels.on(\.saveInput)
      )
   )
   
   override func start() {
      configure()
      guard
         let feed = inputValue?.0,
         let userName = inputValue?.1
      else { return }
      scenario.start()
      
      viewModels.configureLabels(input: (feed, userName))
      viewModels.configureEvents(feed: feed)
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
            viewModels.topBlock,
            viewModels.infoStack,
            Spacer(8),
            viewModels.filterButtons,
            Spacer(8),
            viewModels.commentTableModel,
            Grid.xxx.spacer
         ])
      mainVM.footerStack.arrangedModels([viewModels.commentField])
   }
}

enum FeedDetailSceneState {
   case initial
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
      case .presentComments(let tuple):
         viewModels.commentTableModel.set(.items(tuple + [SpacerItem(size: Grid.x64.value)]))
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
         viewModels.likeButton.models.main.imageTintColor(likeColor)
         viewModels.dislikeButton.models.main.imageTintColor(dislikeColor)
         
         if let reactions = value.0.likes {
            for reaction in reactions {
               if reaction.likeKind?.code == "like" {
                  viewModels.likeButton.models.right.text(String(reaction.counter ?? 0))
               } else if reaction.likeKind?.code == "dislike" {
                  viewModels.dislikeButton.models.right.text(String(reaction.counter ?? 0))
               }
            }
         }
      }
   }
}
