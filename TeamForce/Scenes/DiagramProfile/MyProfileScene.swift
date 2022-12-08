//
//  DiagramProfile.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 04.12.2022.
//

import ReactiveWorks

typealias ProfileID = Int

// TODO: - func Start make call in viewDidLoad and remove vcModel?.on(\.viewDidLoad) everywhere!!!!!

final class MyProfileScene<Asset: ASP>: BaseSceneModel<
   DefaultVCModel,
   BrandDoubleStackVM<Asset.Design>,
   Asset,
   ProfileID
>,
   Configurable,
   Scenarible
{
   lazy var scenario: Scenario = MyProfileScenario<Asset>(
      works: MyProfileWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: MyProfileScenarioInput(
         locationCoordinates: locationManager.on(\.didUpdateLocation),
         selectUserStatus: profileVM.userStatusBlock.on(\.didTap)
      )
   )

   private lazy var profileVM = MyProfileVM<Design>()

   private lazy var locationManager = LocationManager()

   override func start() {
      vcModel?
         .title("Профиль")
         .on(\.viewDidLoad, self) {
            $0.configure()
         }
   }

   func configure() {
      mainVM.bodyStack
         .padding(.verticalOffset(16))

      setState(.initial)

      scenario.start()
      locationManager.start()
   }
}

enum MyProfileSceneState {
   case initial
   case loaded
   //
   case userAvatar(String) // needs to combine to one i think ))
   case userName(String) // needs to combine to one i think ))
   case userStatus(UserStatus) // needs to combine to one i think ))
   case tagsPercents([TagPercent]) // needs to combine to one i think ))
   case userContacts(UserContactData) // needs to combine to one i think ))
   case userWorkPlace(UserWorkData) // needs to combine to one i think ))
   case userRole(UserRoleData) // needs to combine to one i think ))
   //
   case userLocation(UserLocationData)
   //
   case presentUserStatusSelector
}

extension MyProfileScene: StateMachine {
   func setState(_ state: MyProfileSceneState) {
      switch state {
      case .initial:
         mainVM.bodyStack
            .arrangedModels(
               ActivityIndicator<Design>(),
               Spacer()
            )
      case .loaded:
         mainVM.bodyStack
            .arrangedModels(
               profileVM,
               Spacer()
            )
      //
      case .userAvatar(let avatar):
         profileVM.userBlock.avatarButton.url(TeamForceEndpoints.urlBase + avatar, placeHolder: Design.icon.newAvatar)
      case .userName(let name):
         profileVM.userNameBlock.setState(name)
      case .userStatus(let status):
         profileVM.userStatusBlock.setState(status)
      case .tagsPercents(let tagsData):
         profileVM.view.layoutIfNeeded()
         profileVM.diagramBlock.setState(tagsData)
      case .userContacts(let contacts):
         profileVM.userContactsBlock.setState(contacts)
      case .userWorkPlace(let workData):
         profileVM.workingPlaceBlock.setState(workData)
      case .userRole(let roleData):
         profileVM.userRoleBlock.setState(roleData)
      //
      case .userLocation(let locData):
         profileVM.locationBlock.setState(locData)
      //
      case .presentUserStatusSelector:
         Asset.router?.routeAndAwait(.presentModally(.automatic), scene: \.userStatusSelector) { (result: UserStatus?) in
            print(result)
         }
      }
   }
}
