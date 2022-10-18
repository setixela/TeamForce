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
      .set(Design.state.button.plain)
      .title("Создать челлендж")
      .shadow(Design.params.cellShadow)

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

      viewModel.challengesTable
         .on(\.didScroll) { [weak self] in
            self?.send(\.didScroll, $0)
         }
         .on(\.willEndDragging) { [weak self] in
            self?.send(\.willEndDragging, $0)
         }
   }
}

enum ChallengesState {
   case initial
   case presentChallenges([Challenge])
   case presentChallengeDetails((Challenge, Int)) // challenge and profileId
   case presentCreateChallenge

   case presentActivityIndicator
   case hideActivityIndicator
}

extension ChallengesScene: StateMachine {
   func setState(_ state: ChallengesState) {
      switch state {
      case .initial:
         setState(.presentActivityIndicator)
      case .presentChallenges(let challenges):
         setState(.hideActivityIndicator)
         viewModel.setState(.presentChallenges(challenges))
      case .presentChallengeDetails(let value):
         Asset.router?.route(
            .presentModally(.automatic),
            scene: \.challengeDetails,
            payload: value
         )
//         .onSuccess(self) { slf, _ in
//            slf.scenario.start()
//         }
//         .onFail(self) {
//            $0.activity.hidden(true)
//         }
//         .retainBy(retainer)
      case .presentCreateChallenge:
         setState(.presentActivityIndicator)
         Asset.router?.route(
            .presentModally(.automatic),
            scene: \.challengeCreate,
            payload: ()
         ) { [weak self] result in
            switch result {
            case true:
               self?.scenario.start()
            case false:
               self?.setState(.hideActivityIndicator)
            }
         }
      case .presentActivityIndicator:
         activity.hidden(false)
      case .hideActivityIndicator:
         activity.hidden(true)
      }
   }
}
