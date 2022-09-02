//
//  FeedScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.08.2022.
//

import ReactiveWorks
import UIKit

final class FeedScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Assetable,
   Stateable2,
   Communicable,
   Scenarible
{
   typealias State = ViewState
   typealias State2 = StackState

   var events = MainSceneEvents()

   lazy var scenario: Scenario = FeedScenario<Asset>(
      works: FeedWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: FeedScenarioInputEvents(
         loadFeedForCurrentUser: onEvent(\.userDidLoad),
         presentAllFeed: viewModels.filterButtons.onEvent(\.didTapAll),
         presentMyFeed: viewModels.filterButtons.onEvent(\.didTapMy),
         presentPublicFeed: viewModels.filterButtons.onEvent(\.didTapPublic)
      )
   )

   private lazy var viewModels = FeedViewModels<Design>()

   private lazy var activityIndicator = ActivityIndicator<Design>()
   private lazy var errorBlock = CommonErrorBlock<Design>()

   private var state = FeedSceneState.initial

   override func start() {
      set_axis(.vertical)
      set_arrangedModels([
         viewModels.filterButtons,
         activityIndicator,
         errorBlock,
         viewModels.feedTableModel,
      ])

      viewModels.feedTableModel
         .onEvent(\.didScroll) { [weak self] in
            self?.sendEvent(\.didScroll, $0)
         }
         .onEvent(\.willEndDragging) { [weak self] in
            self?.sendEvent(\.willEndDragging, $0)
         }

      setState(.initial)
   }
}

enum FeedSceneState {
   case initial
   case presentFeed(([Feed], String))
   case loadFeedError
}

extension FeedScene: StateMachine {
   func setState(_ state: FeedSceneState) {
      self.state = state
      switch state {
      case .initial:
         activityIndicator.set_hidden(false)
         errorBlock.set_hidden(true)
         break
      case .presentFeed(let tuple):
         activityIndicator.set_hidden(true)
         errorBlock.set_hidden(true)
         viewModels.set(.userName(tuple.1))
         viewModels.feedTableModel.set(.items(tuple.0 + [SpacerItem(size: Grid.x64.value)]))
      case .loadFeedError:
         log("Feed Error!")
         activityIndicator.set_hidden(true)
         errorBlock.set_hidden(false)
      }
   }
}
