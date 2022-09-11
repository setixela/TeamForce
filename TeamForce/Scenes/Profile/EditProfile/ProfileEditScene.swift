//
//  ProfileEditScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks
import UIKit

enum ProfileEditState {
   case initial
   case error
   case userDataDidLoad(UserData)
   case userDataDidChange
   case saveUserData
   case presentImagePicker
   case presentPickedImage(UIImage)
}

final class ProfileEditScene<Asset: AssetProtocol>: ModalDoubleStackModel<Asset>, Scenarible2 {
   lazy var userNamePanel = ProfileEditViewModels<Design>()
   lazy var contactModels = EditContactsViewModels<Design>()

   // OLD
   private lazy var imagePicker = Design.model.common.imagePicker

   lazy var saveButton = Design.button.default
      .title("Сохранить")

   // MARK: - Services

   lazy var scenario: Scenario = ProfileEditScenario(
      works: ProfileEditWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: ProfileEditEvents(
         contactsEvents: contactModels.work,
         saveButtonDidTap: saveButton.on(\.didTap)
      )
   )

   lazy var scenario2: Scenario = AvatarPickingScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: AvatarPickingScenarioEvents(
         startImagePicking: userNamePanel.editPhotoBlock.models.main.on(\.didTap),
         addImageToBasket: imagePicker.onEvent(\.didImagePicked)
      )
   )

   private lazy var works = ProfileEditWorks<Asset>()
   private var balance: Balance?

   private var currentUser: UserData?

   private weak var vcModel: UIViewController?

   convenience init(vcModel: UIViewController?) {
      self.init()

      self.vcModel = vcModel
   }

   override func start() {
      super.start()

      configure()

      scenario2.start()
      scenario.start()
   }

   private func configure() {
      title
         .text(Design.Text.title.myProfile)

      bodyStack
         .arrangedModels([
            userNamePanel.editPhotoBlock,
            Design.model.common.divider,
            EditStack<Design>(title: "КОНТАКТЫ", models: [
               contactModels.surnameEditField,
               contactModels.nameEditField,
               contactModels.middlenameEditField,
               contactModels.emailEditField,
               contactModels.phoneEditField,
            ]),
            Spacer(10),
            saveButton,
            Grid.xxx.spacer,
         ])
   }
}

extension ProfileEditScene: StateMachine {
   func setState(_ state: ProfileEditState) {
      switch state {
      case .initial:
         break
      case .userDataDidChange:
         break
      case .saveUserData:
         break
      case .error:
         break
      case .userDataDidLoad(let userData):
         contactModels.setup(userData)
         userNamePanel.setup(userData)
         currentUser = userData
      case .presentImagePicker:
         guard let baseVC = vcModel else { return }
         imagePicker.sendEvent(\.presentOn, baseVC)
      case .presentPickedImage(let image):
         userNamePanel.editPhotoBlock.models.main.image(image)
      }
   }
}
