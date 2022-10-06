//
//  ChallengesViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

struct ChallengesEvents: InitProtocol {}

final class ChallengesScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Eventable,
   Stateable,
   Assetable,
   Scenarible
{
   typealias Events = ChallengesEvents

   typealias State2 = ViewState
   typealias State = StackState

   var events: EventsStore = .init()

   // MARK: - Scenario

   lazy var scenario: Scenario = ChallengesScenario(
      works: ChallengesWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: ChallengesEvents()
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
}

extension ChallengesScene: StateMachine {
   func setState(_ state: ChallengesState) {
      switch state {
      case .initial:
         break
      }
   }
}
