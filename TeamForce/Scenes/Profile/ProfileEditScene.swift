//
//  ProfileEditScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks
import UIKit

struct ProfileEditViewEvent: InitProtocol {}

final class ProfileEditScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Void
> {
   lazy var userModel = Combos<SComboMRD<ImageViewModel, LabelModel, LabelModel>>()
      .setMain { image in
         image
            .set_image(Design.icon.avatarPlaceholder)
            .set_cornerRadius(52 / 2)
            .set(.size(.square(52)))
      } setRight: { fullName in
         fullName
            .set_textColor(Design.color.text)
            .set_padTop(-8)
            .set_padLeft(12)
      } setDown: { telegram in
         telegram
            .set_textColor(Design.color.textBrand)
            .set_padLeft(12)
            .set(Design.state.label.body2)
      }
      .set_alignment(.center)
      .set_distribution(.fill)
      .set_backColor(Design.color.backgroundInfoSecondary)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_padding(Design.params.cellContentPadding)
      .set_shadow(Design.params.panelMainButtonShadow)
      .set_height(76)

   lazy var email = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Корпоративная почта")
         $1.set_text("-")
      }
   
   lazy var phone = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Мобильный номер")
         $1.set_text("-")
      }
   
   lazy var infoStack = UserProfileStack<Design>()
      .set_arrangedModels([
         LabelModel()
            .set_text("Контакты")
            .set(Design.state.label.caption2),
         email,
         phone,
      ])

   lazy var organization = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Компания")
         $1.set_text("-")
      }
   
   lazy var department = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Подразделение")
         $1.set_text("-")
      }
   
   lazy var hiredAt = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Дата начала работы")
         $1.set_text("-")
      }
   
   lazy var infoStackSecondary = UserProfileStack<Design>()
      .set_arrangedModels([
         LabelModel()
            .set_text("МЕСТО РАБОТЫ")
            .set(Design.state.label.caption2),
         organization,
         department,
         hiredAt,
      ])
   
   lazy var saveButton = Design.button.default
      .set_title("Сохранить")

   // MARK: - Services

   private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)

//   private lazy var works = ProfileEditWorks<Asset>
   private var balance: Balance?
   
   private var currentUser: UserData?

   override func start() {
      vcModel?.sendEvent(\.setTitle, "Профиль")
      configure()
      configureProfile()
   }

   private func configure() {
      mainVM.topStackModel.set(Design.state.stack.bodyStack)
      mainVM.topStackModel
         .set(.backColor(Design.color.backgroundSecondary))
         .set(.axis(.vertical))
         .set(.distribution(.fill))
         .set(.alignment(.fill))
         //.set_padTop(-32)
         .set(.models([
            userModel,
            Spacer(32),
            infoStack,
            Spacer(8),
            infoStackSecondary,
            Grid.xxx.spacer,
         ]))
      
      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .set_arrangedModels([
            saveButton
         ])
   }

   private func configureProfile() {
      safeStringStorageModel
         .doAsync("token")
         .onFail {
            print("token not found")
         }
         .doMap {
            TokenRequest(token: $0)
         }
         .doNext(worker: userProfileApiModel)
         .onSuccess { [weak self] userData in
            self?.setLabels(userData: userData)
            self?.currentUser = userData
         }.onFail {
            print("load profile error")
         }
   }
   
   private func configureButton() {
//      saveButton.onEvent(\.didTap) {
//         self.safeStringStorageModel
//            .doAsync("token")
//            .onFail {
//               print("token not found")
//            }
//            .doMap {
//               if let id = self.currentUser?.profile.id {
//                  UpdateContactRequest(token: $0, id: id, contactId: self.phone.models.down.view.text ?? "77777")
//               }
//               
//            }
//            .doNext(worker: )
//            .onSuccess { [weak self] userData in
//               self?.setLabels(userData: userData)
//            }.onFail {
//               print("load profile error")
//            }
//      }
   }

   private func setLabels(userData: UserData) {
      let profile = userData.profile
      let fullName = profile.surName + " " +
         profile.firstName + " " +
         profile.middleName
      userModel.models.right.set_text(fullName)
      userModel.models.down.set_text("@" + profile.tgName)
      if let urlSuffix = profile.photo {
         userModel.models.main.set_url("http://176.99.6.251:8888" + urlSuffix)
      }

      // infoStackSecondary
      organization.setAll {
         $1.set_text(profile.organization)
      }
      department.setAll {
         $1.set_text(profile.department)
      }
      hiredAt.setAll {
         $1.set_text(profile.hiredAt)
      }
      print("contacts \(profile.contacts)")
      
      //infoStack
      for contact in profile.contacts {
         switch contact.contactType {
         case "@":
            email.setAll {
               $1.set_text(contact.contactId)
            }
         case "P":
            phone.setAll {
               $1.set_text(contact.contactId)
            }
         case "T":
            userModel.models.down.set_text("@" + contact.contactId)
         default:
            print("Contact error")
         }
      }
   }
}

final class ProfileEditTitleBodyDT<Design: DSP>: TitleSubtitleTextFieldY<Design> {
   required init() {
      super.init()
      set_spacing(4)
      setAll { main, down in
         main
            .set_alignment(.left)
            .set(Design.state.label.caption)
            .set_textColor(Design.color.textSecondary)
         down
            .set_alignment(.left)
            .set(Design.state.label.default)
            .set_textColor(Design.color.text)
      }
   }
}
