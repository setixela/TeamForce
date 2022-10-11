//
//  ChallengesViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

final class ChallengesScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Eventable,
   Stateable,
   Assetable,
   Scenarible
{
   typealias Events = MainSceneEvents

   typealias State2 = ViewState
   typealias State = StackState

   var events: EventsStore = .init()

   // MARK: - Scenario

   lazy var scenario: Scenario = ChallengesScenario(
      works: ChallengesWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: ChallengesScenarioInputEvents(
         presentAllChallenges: viewModel.on(\.didTapFilterAll),
         presentActiveChallenges: viewModel.on(\.didTapFilterActive),
         didSelectChallengeIndex: viewModel.on(\.didSelectChallenge)
      )
   )

   // MARK: - View Models

   private lazy var viewModel = ChallengesViewModel<Design>()
   private lazy var activity = ActivityIndicator<Design>()

   override func start() {
      arrangedModels([
         viewModel,
         activity,
      ])
   }
}

enum ChallengesState {
   case initial
   case presentChallenges([Challenge])
   case presentChallengeDetails(Challenge)
}

extension ChallengesScene: StateMachine {
   func setState(_ state: ChallengesState) {
      switch state {
      case .initial:
         break
      case .presentChallenges(let challenges):
         activity.hidden(true)
         viewModel.setState(.presentChallenges(challenges))
      case .presentChallengeDetails(let challenge):
         ProductionAsset.router?.route(\.challengeDetails,
                                       navType: .presentModally(.automatic),
                                       payload: challenge)
      }
   }
}
