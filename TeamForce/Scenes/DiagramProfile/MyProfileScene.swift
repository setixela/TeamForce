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
      events: MyProfileScenarioInput()
   )

   lazy var profileVM = MyProfileVM<Design>()

   override func start() {
      vcModel?
         .title("Профиль")
         .on(\.viewDidLoad, self) {
            $0.configure()
         }
   }

   func configure() {
      mainVM.bodyStack.arrangedModels(
         profileVM,
         Spacer()
      )

      scenario.start()
   }
}

enum MyProfileSceneState {
   case initial
   case userName(name: String, surname: String, nickname: String)
   case userStatus(UserStatus)
   case diagramData(CircleGraphs)
   case userContacts(UserContactData)
   case userWorkPlace(UserWorkData)
   case userRole(UserRoleData)
}

extension MyProfileScene: StateMachine {
   func setState(_ state: MyProfileSceneState) {
      switch state {
      case .initial:
         break
      case .userName(let name, let surname, let nickname):
         profileVM.userNameBlock.setState((name, surname, nickname))
      case .userStatus(let status):
         profileVM.userStatusBlock.setState(status)
      case .diagramData(let diagramData):
         profileVM.diagramBlock.setState(diagramData)
      case .userContacts(let contacts):
         profileVM.userContactsBlock.setState(contacts)
      case .userWorkPlace(let workData):
         profileVM.workingPlaceBlock.setState(workData)
      case .userRole(let roleData):
         profileVM.userRoleBlock.setState(roleData)
      }
   }
}
