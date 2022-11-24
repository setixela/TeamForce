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

   private lazy var filterButtons = ChallengesFilterButtons<Design>()
   private lazy var viewModel = ChallengesViewModel<Design>()
   private lazy var activity = ActivityIndicator<Design>()
   private lazy var errorBlock = CommonErrorBlock<Design>()
   private lazy var darkLoader = DarkLoaderVM<Design>()

   override func start() {
      padding(.horizontalOffset(16))
      setState(.initial)

      viewModel.challengesTable
         .on(\.didScroll) { [weak self] in
            self?.send(\.didScroll, $0)
         }
         .on(\.willEndDragging) { [weak self] in
            self?.send(\.willEndDragging, $0)
         }
         .activateRefreshControl(color: Design.color.iconBrand)
         .on(\.refresh, self) {
            $0.scenario.start()
         }
   }
}

enum ChallengesState {
   case initial
   case presentChallenges([Challenge])
   case presentChallengeDetails((challenge: Challenge, profileId: Int)) // challenge and profileId
   case presentCreateChallenge

   case presentActivityIndicator
   case hideActivityIndicator

   case presentError
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
            .push,
            scene: \.challengeDetails,
            payload: ChallengeDetailsInput.byChallenge(value.challenge)
         )
      case .presentCreateChallenge:
         setState(.presentActivityIndicator)
         Asset.router?.route(
            .presentModally(.pageSheet),
            scene: \.challengeCreate,
            payload: ()
         ) { [weak self] in
            if $0 {
               self?.scenario.start()
            } else {
               self?.setState(.hideActivityIndicator)
            }
         }
      case .presentActivityIndicator:
         arrangedModels([
            activity,
            Spacer()
         ])
      case .hideActivityIndicator:
         arrangedModels([
            createChallengeButton,
            Grid.x16.spacer,
            filterButtons,
            Grid.x16.spacer,
            viewModel
         ])
      case .presentError:
         arrangedModels([
            errorBlock,
            Spacer()
         ])
      }
   }
}
