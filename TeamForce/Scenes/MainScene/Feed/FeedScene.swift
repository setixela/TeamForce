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

   lazy var scenario = FeedScenario<Asset>(
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

   override func start() {
      set_axis(.vertical)
      set_arrangedModels([
         viewModels.filterButtons,
         viewModels.feedTableModel
      ])

      viewModels.feedTableModel
         .onEvent(\.didScroll) { [weak self] in
            self?.sendEvent(\.didScroll, $0)
         }
         .onEvent(\.willEndDragging) { [weak self] in
            self?.sendEvent(\.willEndDragging, $0)
         }

      scenario.start()
   }
}

enum FeedSceneState {
   case presentFeed(([Feed], String))
   case loadFeedError
}

extension FeedScene: StateMachine {
   func setState(_ state: FeedSceneState) {
      switch state {
      case .presentFeed(let tuple):
         viewModels.set(.userName(tuple.1))
         viewModels.feedTableModel.set(.items(tuple.0 + [SpacerItem(size: Grid.x64.value)]))
      case .loadFeedError:
         log("Feed Error!")
      }
   }
}
