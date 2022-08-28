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
      events: FeedScenarioInputEvents(loadFeed: onEvent(\.didAppear))
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
   case presentAllFeed([Feed])
   case loadFeedError
}

extension FeedScene: StateMachine {
   func setState(_ state: FeedSceneState) {
      switch state {
      case .presentAllFeed(let array):
         viewModels.feedTableModel.set(.items(array + [SpacerItem(size: Grid.x64.value)]))
      case .loadFeedError:
         break
      }
   }
}
