//
//  DiagramProfile.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 04.12.2022.
//

import ReactiveWorks

typealias ProfileID = Int

final class MyProfileScene<Asset: ASP>: BaseSceneModel<
   DefaultVCModel,
   BrandDoubleStackVM<Asset.Design>,
   Asset,
   Void
>,
   Configurable,
   Scenarible
{
   lazy var scenario: Scenario = MyProfileScenario<Asset>(
      works: MyProfileWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: MyProfileScenarioInput(
         // loadMyProfile: on(\.input)
      )
   )

   lazy var diagramProfileVM = MyProfileVM<Design>()

   override func start() {
      vcModel?
         .title("Профиль")
         .on(\.viewDidLoad, self) {
            $0.configure()
         }
   }

   func configure() {
      mainVM.bodyStack.arrangedModels(
         diagramProfileVM,
         Spacer()
      )

      scenario.start()
   }
}

enum MyProfileSceneState {
   case initial
   case profile(UserData)
   case diagramData(CircleGraphs)
}

extension MyProfileScene: StateMachine {
   func setState(_ state: MyProfileSceneState) {
      switch state {
      case .initial:
         break
      case .profile(let userData):
         diagramProfileVM.userNameBlock.setState(
            .setup(
               name: userData.profile.firstName.string,
               surname: userData.profile.surName.string,
               nickname: userData.profile.tgName.string
            )
         )
      case .diagramData(let diagramData):
         diagramProfileVM.diagramBlock.setState(diagramData)
      }
   }
}
