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
            .image(Design.icon.avatarPlaceholder)
            .cornerRadius(52 / 2)
            .set(.size(.square(52)))
      } setRight: { fullName in
         fullName
            .textColor(Design.color.text)
            .padTop(-8)
            .padLeft(12)
      } setDown: { telegram in
         telegram
            .textColor(Design.color.textBrand)
            .padLeft(12)
            .set(Design.state.label.body2)
      }
      .alignment(.center)
      .distribution(.fill)
      .backColor(Design.color.backgroundInfoSecondary)
      .cornerRadius(Design.params.cornerRadius)
      .padding(Design.params.cellContentPadding)
      .shadow(Design.params.panelMainButtonShadow)
      .height(76)

   lazy var firstname = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.text("Имя")
         $1
            .placeholder("Имя")
            .backColor(.clear)
      }
      .borderColor(Design.color.textSecondary)
      .borderWidth(1.0)
      .padding(Design.params.contentPadding)
      .cornerRadius(Design.params.cornerRadius)
      .alignment(.fill)
   
   lazy var surname = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.text("Фамилия")
         $1
            .placeholder("Фамилия")
            .backColor(.clear)
      }
      .borderColor(Design.color.textSecondary)
      .borderWidth(1.0)
      .padding(Design.params.contentPadding)
      .cornerRadius(Design.params.cornerRadius)
      .alignment(.fill)
   
   lazy var middleName = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.text("Отчество")
         $1
            .placeholder("Отчество")
            .backColor(.clear)
      }
      .borderColor(Design.color.textSecondary)
      .borderWidth(1.0)
      .padding(Design.params.contentPadding)
      .cornerRadius(Design.params.cornerRadius)
      .alignment(.fill)
   
   lazy var email = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.text("Корпоративная почта")
         $1
            .placeholder("Корпоративная почта")
            .backColor(.clear)
      }
      .borderColor(Design.color.textSecondary)
      .borderWidth(1.0)
      .padding(Design.params.contentPadding)
      .cornerRadius(Design.params.cornerRadius)
      .alignment(.fill)
      
   lazy var phone = ProfileEditTitleBodyDT<Design>()
      .setAll {
         $0.text("Мобильный номер")
         $1
            .placeholder("Мобильный номер")
            .backColor(.clear)
      }
      .borderColor(Design.color.textSecondary)
      .borderWidth(1.0)
      .padding(Design.params.contentPadding)
      .cornerRadius(Design.params.cornerRadius)
      .alignment(.fill)
   
   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("Контакты")
            .set(Design.state.label.caption2),
         surname,
         firstname,
         middleName,
         email,
         phone,
      ])
      .alignment(.fill)
      
   lazy var saveButton = Design.button.default
      .title("Сохранить")

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
         // .padTop(-32)
         .set(.models([
            userModel,
            Spacer(32),
            infoStack,
            Grid.xxx.spacer,
         ]))
      
      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .arrangedModels([
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
      saveButton.on(\.didTap) {
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
      userModel.models.right.text(fullName)
      userModel.models.down.text("@" + profile.tgName)
      if let urlSuffix = profile.photo {
         userModel.models.main.url(TeamForceEndpoints.urlBase + urlSuffix)
      }
      
      // infoStack
      firstname.models.down.text(profile.firstName.string)
      surname.models.down.text(profile.surName.string)
      middleName.models.down.text(profile.middleName.string)
      if let contacts = profile.contacts {
         for contact in contacts {
            switch contact.contactType {
            case "@":
               email.setAll {
                  $1.text(contact.contactId)
               }
            case "P":
               phone.setAll {
                  $1.text(contact.contactId)
               }
            case "T":
               userModel.models.down.text("@" + contact.contactId)
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
      spacing(4)
      setAll { main, down in
         main
            .alignment(.left)
            .set(Design.state.label.caption)
            .textColor(Design.color.textSecondary)
         down
            .alignment(.left)
            .set(Design.state.label.default)
            .textColor(Design.color.text)
      }
   }
}

extension Optional where Wrapped == String {
   var string: String { self ?? "" }
}
