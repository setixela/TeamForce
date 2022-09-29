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
      DoubleStacksBrandedVM<Asset.Design>,
      Asset,
      (Feed, String)
   >, Scenarible
{
   typealias State = ViewState
   typealias State2 = StackState
   
   private lazy var viewModels = FeedDetailViewModels<Design>()
   
   lazy var scenario1 = FeedDetailScenario<Asset>(
      works: FeedDetailWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: FeedDetailEvents(
         presentComment: viewModels.filterButtons.on(\.didTapComments),
         presentReactions: viewModels.filterButtons.on(\.didTapReactions)
      )
   )
   
   lazy var scenario: Scenario = scenario1
   
   override func start() {
      guard let transactionId = inputValue?.0.transaction.id else { return }
      configure()
      guard
         let feed = inputValue?.0,
         let userName = inputValue?.1
      else { return }
      
      viewModels.configureLabels(input: (feed, userName))
      
      scenario1.transactId = transactionId
      scenario.start()
   }

   private var state = FeedDetailSceneState.initial
   private func configure() {
      mainVM.headerStack.arrangedModels([Grid.x64.spacer])
      mainVM.bodyStack
         .set(Design.state.stack.default)
         .alignment(.fill)
         .distribution(.fill)
         .set(.backColor(Design.color.backgroundSecondary))
         .arrangedModels([
            viewModels.topBlock,
            viewModels.infoStack,
            Spacer(8),
            viewModels.filterButtons,
            Spacer(8),
            viewModels.commentTableModel,
            Grid.xxx.spacer
         ])
   }
}

enum FeedDetailSceneState {
   case initial
   case presentComments([Comment])
}

extension FeedDetailScene: StateMachine {
   func setState(_ state: FeedDetailSceneState) {
      self.state = state
      switch state {
      case .initial:
         print("hello")
      case .presentComments(let tuple):
         viewModels.commentTableModel.set(.items(tuple + [SpacerItem(size: Grid.x64.value)]))
      }
   }
}
