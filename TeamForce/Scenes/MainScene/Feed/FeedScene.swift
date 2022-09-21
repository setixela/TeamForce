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
         presentAllFeed: viewModels.filterButtons.on(\.didTapAll),
         presentMyFeed: viewModels.filterButtons.on(\.didTapMy),
         presentPublicFeed: viewModels.filterButtons.on(\.didTapPublic),
         presentProfile: viewModels.presenter.on(\.didSelect),
         reactionPressed: viewModels.presenter.on(\.reactionPressed)
      )
   )

   private lazy var viewModels = FeedViewModels<Design>()

   private lazy var activityIndicator = ActivityIndicator<Design>()
   private lazy var errorBlock = CommonErrorBlock<Design>()

   private var state = FeedSceneState.initial

   override func start() {
      axis(.vertical)
      arrangedModels([
         viewModels.filterButtons,
         activityIndicator,
         errorBlock,
         viewModels.feedTableModel,
      ])

      viewModels.feedTableModel
         .on(\.didScroll) { [weak self] in
            self?.sendEvent(\.didScroll, $0)
         }
         .on(\.willEndDragging) { [weak self] in
            self?.sendEvent(\.willEndDragging, $0)
         }

      setState(.initial)
   }
}

enum FeedSceneState {
   case initial
   case presentFeed(([Feed], String))
   case loadFeedError
   case presentProfile(Int)
   case reactionChanged
}

extension FeedScene: StateMachine {
   func setState(_ state: FeedSceneState) {
      self.state = state
      switch state {
      case .initial:
         activityIndicator.hidden(false)
         errorBlock.hidden(true)
      case .presentFeed(let tuple):
         activityIndicator.hidden(true)
         errorBlock.hidden(true)
         viewModels.set(.userName(tuple.1))
         viewModels.feedTableModel.set(.items(tuple.0 + [SpacerItem(size: Grid.x64.value)]))
      case .loadFeedError:
         log("Feed Error!")
         activityIndicator.hidden(true)
         errorBlock.hidden(false)
      case .presentProfile(let id):
         Asset.router?.route(\.profile, navType: .push, payload: id)
      case .reactionChanged:
         print("Hello")
      }
   }
}
