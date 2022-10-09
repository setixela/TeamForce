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
         presentActiveChallenges: viewModel.on(\.didTapFilterActive)
      )
   )

   // MARK: - View Models

   private lazy var viewModel = ChallengesViewModel<Design>()

   override func start() {
      arrangedModels([
         viewModel,
      ])
   }
}

enum ChallengesState {
   case initial
   case presentChallenges([Challenge])
}

extension ChallengesScene: StateMachine {
   func setState(_ state: ChallengesState) {
      switch state {
      case .initial:
         break
      case .presentChallenges(let challenges):
         viewModel.setState(.presentChallenges(challenges))
      }
   }
}
