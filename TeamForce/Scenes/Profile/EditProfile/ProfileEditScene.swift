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
   //
   private lazy var userNamePanel = ProfileEditViewModels<Design>()
   private lazy var contactModels = EditContactsViewModels<Design>()
   private lazy var workPlaceModels = WorkingPlaceViewModels<Design>()
//   private lazy var otherViewModels = OtherViewModels<Design>()

   private lazy var imagePicker = Design.model.common.imagePicker

   private lazy var saveButton = Design.button.default
      .title("Сохранить")

   // MARK: - Services

   private lazy var works = ProfileEditWorks<Asset>()

   lazy var scenario: Scenario = ProfileEditScenario(
      works: works,
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

   private weak var vcModel: UIViewController?

   convenience init(vcModel: UIViewController?) {
      self.init()

      self.vcModel = vcModel
   }

   override func start() {
      super.start()

      configure()

      scenario.start()
      scenario2.start()
   }

   private func configure() {
      title
         .text(Design.Text.title.myProfile)

      bodyStack
         .arrangedModels([
            userNamePanel.editPhotoBlock,
            Design.model.common.divider,
            ScrollViewModelY()
               .set(.arrangedModels([
                  EditStack<Design>(title: "КОНТАКТЫ", models: [
                     contactModels.surnameEditField,
                     contactModels.nameEditField,
                     contactModels.middlenameEditField,
                     contactModels.emailEditField,
                     contactModels.phoneEditField
                  ]),
                  Design.model.common.divider,
                  EditStack<Design>(title: "МЕСТО РАБОТЫ", models: [
                     workPlaceModels.companyTitleBody,
                     workPlaceModels.departmentTitleBody,
                     workPlaceModels.startWorkTitleBody
                  ]),
                  Design.model.common.divider,
                  EditStack<Design>(title: "ТЕЛЕГРАМ", models: [
                     contactModels.telegramEditField
                  ]),
                  Grid.x24.spacer
               ]))
         ])

      footerStack
         .arrangedModels([
            saveButton
         ])
         .padding(.top(Grid.x16.value))
         .padBottom(Grid.x16.value)
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
         workPlaceModels.setup(userData)
         //otherViewModels.setup(userData)
      case .presentImagePicker:
         imagePicker.sendEvent(\.presentOn, vcModel)
      case .presentPickedImage(let image):
         userNamePanel.editPhotoBlock.models.main.image(image)
      }
   }
}
