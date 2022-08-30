//
//  ProfileViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import ReactiveWorks
import UIKit

struct ProfileViewEvent: InitProtocol {}

final class ProfileScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   TripleStacksBrandedVM<Asset.Design>,
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

   lazy var email = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Корпоративная почта")
         $1.set_text("-")
      }
   
   lazy var phone = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.set_text("Мобильный номер")
         $1.set_text("-")
      }
   
   lazy var infoStack = UserProfileStack<Design>()
      .set_arrangedModels([
         LabelModel()
            .set_text("ИНФОРМАЦИЯ")
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
   
   lazy var editButton = Design.button.default
      .set_title("Edit")

   // MARK: - Services

   private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)

   private var balance: Balance?

   override func start() {
      vcModel?.sendEvent(\.setTitle, "Профиль")
      configure()
      configureProfile()
   }

   private func configure() {
      mainVM.footerStack.view.removeFromSuperview()
      mainVM.headerStack.set_arrangedModels([Grid.x128.spacer])
      mainVM.bodyStack
         .set(.backColor(Design.color.backgroundSecondary))
         .set(.axis(.vertical))
         .set(.distribution(.fill))
         .set(.alignment(.fill))
         .set_padTop(-32)
         .set(.models([
            userModel,
            Spacer(32),
            infoStack,
            Spacer(8),
            infoStackSecondary,
            Spacer(8),
            editButton,
            Grid.xxx.spacer,
         ]))
      
      editButton.onEvent(\.didTap) {
         Asset.router?.route(\.profileEdit, navType: .presentModally(.formSheet))
      }
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
         }.onFail {
            print("load profile error")
         }
   }

   private func setLabels(userData: UserData) {
      let profile = userData.profile
      let fullName = profile.surName + " " +
         profile.firstName + " " +
      (profile.middleName ?? "")
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

final class SettingsTitleBodyDT<Design: DSP>: TitleSubtitleY<Design> {
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

final class UserProfileStack<Design: DSP>: StackModel, Designable {
   override func start() {
      super.start()

      set_backColor(Design.color.backgroundInfoSecondary)
      set_padding(.init(top: 16, left: 16, bottom: 16, right: 16))
      set_cornerRadius(Design.params.cornerRadiusSmall)
      set_spacing(12)
      set_distribution(.equalSpacing)
      set_alignment(.leading)
   }
}
