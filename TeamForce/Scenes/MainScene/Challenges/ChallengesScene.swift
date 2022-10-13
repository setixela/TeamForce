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
         saveProfileId: on(\.userDidLoad),
         presentAllChallenges: filterButtons.on(\.didTapFilterAll),
         presentActiveChallenges: filterButtons.on(\.didTapFilterActive),
         didSelectChallengeIndex: viewModel.on(\.didSelectChallenge),
         createChallenge: createChallengeButton.on(\.didTap)
      )
   )

   // MARK: - View Models

   private lazy var createChallengeButton = ButtonModel()
      .set(Design.state.button.default)
      .title("Создать челлендж")

   private lazy var filterButtons = CreateChallengePanel<Design>()
   private lazy var viewModel = ChallengesViewModel<Design>()
   private lazy var activity = ActivityIndicator<Design>()

   override func start() {
      arrangedModels([
         createChallengeButton,
         Grid.x16.spacer,
         filterButtons,
         Grid.x16.spacer,
         activity,
         viewModel,
      ])
   }
}

enum ChallengesState {
   case initial
   case presentChallenges([Challenge])
   case presentChallengeDetails((Challenge, Int)) // challenge and profileId
   case presentCreateChallenge
}

extension ChallengesScene: StateMachine {
   func setState(_ state: ChallengesState) {
      switch state {
      case .initial:
         break
      case .presentChallenges(let challenges):
         activity.hidden(true)
         viewModel.setState(.presentChallenges(challenges))
      case .presentChallengeDetails(let value):
         Asset.router?.route(
            \.challengeDetails,
            navType: .presentModally(.automatic),
            payload: value
         )
         .onSuccess {
            print("reload table")
         }
         .onFail {
            print("doNothing")
         }
         .retainBy(retainer)
      case .presentCreateChallenge:
         Asset.router?.route(
            \.challengeCreate,
            navType: .presentModally(.automatic),
            payload: ()
         )
      }
   }
}
