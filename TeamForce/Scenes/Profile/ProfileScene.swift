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
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   Void
> {
   lazy var userModel = Design.model.profile.userEditPanel

   lazy var email = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Корпоративная почта")
         $1.text("-")
      }

   lazy var phone = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Мобильный номер")
         $1.text("-")
      }

   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("ИНФОРМАЦИЯ")
            .set(Design.state.label.caption2),
         email,
         phone,
      ])

   lazy var organization = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Компания")
         $1.text("-")
      }

   lazy var department = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Подразделение")
         $1.text("-")
      }

   lazy var hiredAt = SettingsTitleBodyDT<Design>()
      .setAll {
         $0.text("Дата начала работы")
         $1.text("-")
      }

   lazy var infoStackSecondary = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("МЕСТО РАБОТЫ")
            .set(Design.state.label.caption2),
         organization,
         department,
         hiredAt,
      ])

   lazy var bottomPopupPresenter = Design.model.common.bottomPopupPresenter

   lazy var editProfileModel = ProfileEditScene<Asset>()

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
      mainVM.headerStack.arrangedModels([Grid.x64.spacer])
      mainVM.bodyStack
         .set(.backColor(Design.color.backgroundSecondary))
         .set(.axis(.vertical))
         .set(.distribution(.fill))
         .set(.alignment(.fill))
         .padTop(-32)
         .set(.arrangedModels([
            userModel,
            Spacer(32),
            infoStack,
            Spacer(8),
            infoStackSecondary,
            Grid.xxx.spacer,
         ]))

      userModel.models.right2.on(\.didTap, weak: self) {
         $0.bottomPopupPresenter.send(\.present, ($0.editProfileModel, $0.vcModel?.view.rootSuperview))
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
      let fullName = profile.surName.string + " " +
         profile.firstName.string + " " + profile.middleName.string
      userModel.models.right.text(fullName)
      userModel.models.down.text("@" + profile.tgName)
      if let urlSuffix = profile.photo {
         userModel.models.main.url(TeamForceEndpoints.urlBase + urlSuffix)
      }

      // infoStackSecondary
      organization.setAll {
         $1.text(profile.organization)
      }
      department.setAll {
         $1.text(profile.department)
      }
      hiredAt.setAll {
         $1.text(profile.hiredAt.string)
      }
      print("contacts \(profile.contacts)")

      // infoStack
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

final class SettingsTitleBodyDT<Design: DSP>: TitleSubtitleY<Design> {
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

final class UserProfileStack<Design: DSP>: StackModel, Designable {
   override func start() {
      super.start()

      backColor(Design.color.backgroundInfoSecondary)
      padding(.init(top: 16, left: 16, bottom: 16, right: 16))
      cornerRadius(Design.params.cornerRadiusSmall)
      spacing(12)
      distribution(.equalSpacing)
      alignment(.leading)
   }
}
