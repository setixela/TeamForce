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

      view.on(\.willAppear, self) {
         $0.configure()
      }

      setState(.initial)
   }
}

extension FeedScene: Configurable {
   func configure() {
      bodyStack.arrangedModels([
         viewModels.filterButtons,
      ])
      .padding(.horizontalOffset(8))
      .padBottom(8)

      footerStack.arrangedModels([
         activityIndicator,
         errorBlock,
         hereIsEmptyBlock.hidden(true),
         viewModels.feedTableModel,
      ])

      viewModels.feedTableModel
         .on(\.didScroll) { [weak self] in
            self?.send(\.didScroll, $0)
         }
         .on(\.willEndDragging) { [weak self] in
            self?.send(\.willEndDragging, $0)
         }
   }
}

enum FeedSceneState {
   case initial
   case presentFeed(([FeedElement], String))
   case loadFeedError
   case presentProfile(Int)
   case reactionChanged
   case presentDetailView((feed: FeedElement, profileId: Int))
   case updateFeed([FeedElement])
   case updateFeedAtIndex(FeedElement, Int)
}

extension FeedScene: StateMachine {
   func setState(_ state: FeedSceneState) {
      self.state = state
      switch state {
      case .initial:
         footerStack.arrangedModels([
            activityIndicator,
         ])
         errorBlock.hidden(true)
      case .presentFeed(let tuple):
         hereIsEmptyBlock.hidden(true)
         activityIndicator.hidden(true)
         errorBlock.hidden(true)
         viewModels.set(.userName(tuple.1))

         guard !tuple.0.isEmpty else {
            viewModels.feedTableModel.hidden(true)
            hereIsEmptyBlock.hidden(false)
            return
         }

         viewModels.feedTableModel.hidden(false)
         viewModels.feedTableModel.set(.items(tuple.0 + [SpacerItem(size: Grid.x64.value)]))
      case .loadFeedError:
         log("Feed Error!")
         activityIndicator.hidden(true)
         errorBlock.hidden(false)
      case .presentProfile(let id):
         Asset.router?.route(.push, scene: \.profile, payload: id)
      case .reactionChanged:
         print("Hello")
      case .presentDetailView(let tuple):
         switch tuple.feed.objectSelector {
         case "T":
            Asset.router?.route(
               .push,
               scene: \.transactDetails,
               payload: tuple.feed
            )
         case "Q":
            Asset.router?.route(
               .presentModally(.automatic),
               scene: \.challengeDetails,
               payload: ChallengeDetailsSceneInput(feed: tuple.feed,
                                                   profileId: tuple.profileId,
                                                   currentButton: 0)
            )
         case "R":
            Asset.router?.route(
               .presentModally(.automatic),
               scene: \.challengeDetails,
               payload: ChallengeDetailsSceneInput(feed: tuple.feed,
                                                   profileId: tuple.profileId,
                                                   currentButton: 3)
            )
         default:
            break
         }
      case .updateFeed(let value):
         viewModels.feedTableModel.set(.items(value + [SpacerItem(size: Grid.x64.value)]))
      case .updateFeedAtIndex(let feed, let index):
         viewModels.feedTableModel.set(.updateItemAtIndex(feed, index))
      }
   }
}
