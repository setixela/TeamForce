//
//  FeedScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.08.2022.
//

import ReactiveWorks
import UIKit

final class FeedScene<Asset: AssetProtocol>: DoubleStacksModel,
   Assetable,
   Eventable,
   Scenarible
{
   typealias Events = MainSceneEvents
   typealias State = ViewState
   typealias State2 = StackState

   var events: EventsStore = .init()

   lazy var scenario: Scenario = FeedScenario<Asset>(
      works: FeedWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: FeedScenarioInputEvents(
         loadFeedForCurrentUser: on(\.userDidLoad),
         filterTapped: viewModels.filterButtons.on(\.didTapButtons),
         //presentAllFeed: viewModels.filterButtons.on(\.didTapButtons),
         //presentTransactions: viewModels.filterButtons.on(\.didTapMy),
//         presentPublicFeed: viewModels.filterButtons.on(\.didTapPublic),
         presentProfile: viewModels.presenter.on(\.didSelect),
         reactionPressed: viewModels.presenter.on(\.reactionPressed),
         presentDetail: viewModels.feedTableModel.on(\.didSelectRowInt),
         pagination: viewModels.feedTableModel.on(\.pagination)
      )
   )

   private lazy var viewModels = FeedViewModels<Design>()

   private lazy var activityIndicator = ActivityIndicator<Design>()
   private lazy var errorBlock = CommonErrorBlock<Design>()
   private lazy var hereIsEmptyBlock = HereIsEmptySpacedBlock<Design>()

   private var state = FeedSceneState.initial

   override func start() {
      super.start()

      bodyStack.arrangedModels([
         viewModels.filterButtons
      ])
      .padding(.horizontalOffset(8))
      .padBottom(8)

      footerStack.arrangedModels([
         activityIndicator,
         errorBlock,
         hereIsEmptyBlock,
         viewModels.feedTableModel,
      ])

      viewModels.feedTableModel
         .on(\.didScroll) { [weak self] in
            self?.send(\.didScroll, $0)
         }
         .on(\.willEndDragging) { [weak self] in
            self?.send(\.willEndDragging, $0)
         }

      setState(.initial)
   }
}

enum FeedSceneState {
   case initial
   case presentFeed(([NewFeed], String))
   case loadFeedError
   case presentProfile(Int)
   case reactionChanged
   case presentDetailView(NewFeed)
   case updateFeed([NewFeed])
   case updateFeedAtIndex(NewFeed, Int)
   case presentChallengeDetails(ChallengeDetailsSceneInput)
}

extension FeedScene: StateMachine {
   func setState(_ state: FeedSceneState) {
      self.state = state
      switch state {
      case .initial:
         activityIndicator.hidden(false)
         errorBlock.hidden(true)
         hereIsEmptyBlock.hidden(true)
      case .presentFeed(let tuple):
         activityIndicator.hidden(true)
         errorBlock.hidden(true)
         viewModels.set(.userName(tuple.1))

         guard !tuple.0.isEmpty else {
            viewModels.feedTableModel.hidden(true)
            hereIsEmptyBlock.hidden(false)
            return
         }

         viewModels.feedTableModel.hidden(false)
         hereIsEmptyBlock.hidden(true)
         viewModels.feedTableModel.set(.items(tuple.0 + [SpacerItem(size: Grid.x64.value)]))
      case .loadFeedError:
         log("Feed Error!")
         activityIndicator.hidden(true)
         errorBlock.hidden(false)
      case .presentProfile(let id):
         Asset.router?.route(.push, scene: \.profile, payload: id)
      case .reactionChanged:
         print("Hello")
      case .presentDetailView(let feed):
         Asset.router?.route(.push, scene: \.feedDetail, payload: (feed, viewModels.userName))
      case .updateFeed(let value):
         viewModels.feedTableModel.set(.items(value + [SpacerItem(size: Grid.x64.value)]))
      case .updateFeedAtIndex(let feed, let index):
         viewModels.feedTableModel.set(.updateItemAtIndex(feed, index))
         
      case .presentChallengeDetails(let value):
         Asset.router?.route(
            .presentModally(.automatic),
            scene: \.challengeDetails,
            payload: value
         )
      }
   }
}
