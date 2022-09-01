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

   lazy var firstname = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Имя")
         $1
            .set_placeholder("Имя")
            .set_backColor(.clear)
      }
      .set_borderColor(Design.color.textSecondary)
      .set_borderWidth(1.0)
      .set_padding(Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_alignment(.fill)
   
   lazy var surname = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Фамилия")
         $1
            .set_placeholder("Фамилия")
            .set_backColor(.clear)
      }
      .set_borderColor(Design.color.textSecondary)
      .set_borderWidth(1.0)
      .set_padding(Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_alignment(.fill)
   
   lazy var middleName = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Отчество")
         $1
            .set_placeholder("Отчество")
            .set_backColor(.clear)
      }
      .set_borderColor(Design.color.textSecondary)
      .set_borderWidth(1.0)
      .set_padding(Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_alignment(.fill)
   
   lazy var email = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Корпоративная почта")
         $1
            .set_placeholder("Корпоративная почта")
            .set_backColor(.clear)
      }
      .set_borderColor(Design.color.textSecondary)
      .set_borderWidth(1.0)
      .set_padding(Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_alignment(.fill)
      
   lazy var phone = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Мобильный номер")
         $1
            .set_placeholder("Мобильный номер")
            .set_backColor(.clear)
      }
      .set_borderColor(Design.color.textSecondary)
      .set_borderWidth(1.0)
      .set_padding(Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_alignment(.fill)
   
   lazy var infoStack = UserProfileStack<Design>()
      .set_arrangedModels([
         LabelModel()
            .set_text("Контакты")
            .set(Design.state.label.caption2),
         surname,
         firstname,
         middleName,
         email,
         phone,
      ])
      .set_alignment(.fill)
      
   lazy var saveButton = Design.button.default
      .set_title("Сохранить")

   // MARK: - Services

   private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)

   private lazy var works = ProfileEditWorks<Asset>()
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
         // .set_padTop(-32)
         .set(.models([
            userModel,
            Spacer(32),
            infoStack,
            Grid.xxx.spacer,
         ]))
      
      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .set_arrangedModels([
            saveButton,
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
            self?.configureButton()
         }.onFail {
            print("load profile error")
         }
   }
   
   private func configureButton() {
      print("I am here")
      var emailId: Int?
      var phoneId: Int?
      guard let contacts = self.currentUser?.profile.contacts else { return }
      
      for contact in contacts {
         if contact.contactType == "@" {
            emailId = contact.id
         }
         if contact.contactType == "P" {
            phoneId = contact.id
         }
      }
      print("I am here 2")
      saveButton.onEvent(\.didTap) {
         guard let emailId = emailId else {
            return
         }

         self.works.updateContact
            .doAsync((emailId, self.email.models.down.view.text ?? "email@gmail.com"))
            .onSuccess {
               print("Succeessss")
            }
            .onFail {
               print("FAIIIL")
            }
      }
   }

   private func setLabels(userData: UserData) {
      let profile = userData.profile
      let fullName = profile.surName.string + " " +
      profile.firstName.string + " " +
         profile.middleName.string
      userModel.models.right.set_text(fullName)
      userModel.models.down.set_text("@" + profile.tgName)
      if let urlSuffix = profile.photo {
         userModel.models.main.set_url(TeamForceEndpoints.urlBase + urlSuffix)
      }
      
      // infoStack
      firstname.models.down.set_text(profile.firstName.string)
      surname.models.down.set_text(profile.surName.string)
      middleName.models.down.set_text(profile.middleName.string)
      if let contacts = profile.contacts {
         for contact in contacts {
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

extension Optional where Wrapped == String {
   var string: String { self ?? "" }
}
