//
//  ProfileViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import ReactiveWorks
import UIKit

struct ProfileViewEvent: InitProtocol {}

final class ProfileViewModel<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState
   var events: BalanceViewEvent = .init()

   lazy var userModel = Combos<SComboMRD<ImageViewModel, LabelModel, LabelModel>>()
      .setMain { image in
         image
            .set_image(Design.icon.avatarPlaceholder)
            .set_url(String.randomUrlImage)
            .set_cornerRadius(52/2)
            .set(.size(.square(52)))
      } setRight: { fullName in
         fullName
            .set_color(Design.color.text)
            .set_padTop(-8)
            .set_padLeft(12)
      } setDown: { telegram in
         telegram
            .set_color(Design.color.textBrand)
            .set_padLeft(12)
            .set_font(Design.font.body2)
      }
      .set_alignment(.center)
      .set_distribution(.fill)
      .set_backColor(Design.color.inactiveButtonBack)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_padding(Design.params.cellContentPadding)
      .set_shadow(Design.params.panelMainButtonShadow)
      .set_height(76)

   lazy var infoFrame = Combos<SComboMDD<LabelModel, CustomCellModel<Design>, CustomCellModel<Design>>>()
      .setMain { header in
         header
            .set_text("ИНФОРМАЦИЯ")
            .set_color(Design.color.textSecondary)
      } setDown: { email in
         email.title.set_text("Корпоративная почта")
      } setDown2: { phoneNumber in
         phoneNumber.title.set_text("Мобильный номер")
      }
      .set_backColor(Design.color.inactiveButtonBack)
      .set_padding(Asset.Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadiusSmall)

//   lazy var newFrame = Combos<SComboMD<LabelModel, Combos<SComboMDD<CustomCellModel<Design>, CustomCellModel<Design>, CustomCellModel<Design>>>>>()
//      .setMain { header in
//         header
//            .set_text("Место работы")
//            .set_color(Design.color.textSecondary)
//      } setDown: { <#ViewModelProtocol#> in
//         <#code#>
//      }

   lazy var secondaryFrame = Combos<SComboMDD<CustomCellModel<Design>, CustomCellModel<Design>, CustomCellModel<Design>>>()
      .setMain { company in
         company.title.set_text("Компания")
         company.set_height(Grid.x60.value)
      } setDown: { department in
         department.title.set_text("Подразделение")
         department.set_height(Grid.x60.value)
      } setDown2: { phoneNumber in
         phoneNumber.title.set_text("Дата начала работы")
         phoneNumber.set_height(Grid.x60.value)
      }
      .set_backColor(Design.color.inactiveButtonBack)
      .set_padding(Asset.Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadiusSmall)

   // MARK: - Services

   private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)

   private var balance: Balance?

   override func start() {
      configure()
      configureProfile()
   }

   private func configure() {
      set(Design.state.stack.default)
      set(.backColor(Design.color.backgroundSecondary))
      set(.axis(.vertical))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set_padTop(-72)
      set(.models([
         userModel,
         Spacer(16),
         infoFrame,
         Spacer(8),
         secondaryFrame,
         Grid.xxx.spacer,
      ]))
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
         profile.middleName
      userModel.models.right.set_text(fullName)
      userModel.models.down.set_text("@" + profile.tgName)

      guard !profile.contacts.isEmpty else { return }

      infoFrame.models.down.set(.text(profile.contacts[0].contactId))
      infoFrame.models.down2.set(.text("Нет в базе данных"))

      secondaryFrame.models.main.set(.text(profile.organization))
      secondaryFrame.models.down.set(.text(profile.department))
      secondaryFrame.models.down2.set(.text(profile.hiredAt))
   }
}
