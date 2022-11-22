//
//  SettingsViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 22.08.2022.
//

import ReactiveWorks
import UIKit

struct SettingsViewEvent: InitProtocol {}

final class SettingsScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   BrandDoubleStackVM<Asset.Design>,
   Asset,
   UserData
> {
   // MARK: - Frame Cells

   private lazy var organizationsModel = ChangeOrganizationVM<Design>()

   lazy var general = Combos<SComboMDD<LabelModel, DoubleLabelHorizontal, DoubleLabelHorizontal>>()
      .setMain { header in
         header
            .text("Общие")
            .textColor(Design.color.textContrastSecondary)
      } setDown: {
         $0
            .setMain {
               $0
                  .text("Язык")
                  .textColor(Design.color.text)
            } setRight: {
               $0
                  .text("Русский")
                  .textColor(Design.color.textContrastSecondary)
            }
            .height(Grid.x60.value)

      } setDown2: {
         $0
            .setMain {
               $0
                  .text("Тема")
                  .textColor(Design.color.text)
            } setRight: {
               $0
                  .text("Как в системе")
                  .textColor(Design.color.textContrastSecondary)
            }
            .distribution(.equalCentering)
            .height(Grid.x60.value)
      }
      .backColor(Design.color.infoSecondary)
      .padding(Asset.Design.params.contentPadding)
      .cornerRadius(Design.params.cornerRadiusSmall)

   lazy var help = Combos<SComboMDD<LabelModel, DoubleLabelHorizontal, DoubleLabelHorizontal>>()
      .setMain { header in
         header
            .text("Помощь")
            .textColor(Design.color.textContrastSecondary)
      } setDown: {
         $0
            .setMain {
               $0
                  .text("Обратная связь")
                  .textColor(Design.color.text)
            } setRight: {
               $0
                  .text(">")
                  .textColor(Design.color.textContrastSecondary)
            }
            .height(Grid.x60.value)

      } setDown2: {
         $0
            .setMain {
               $0
                  .text("О приложении")
                  .textColor(Design.color.text)
            } setRight: {
               $0
                  .text(">")
                  .textColor(Design.color.textContrastSecondary)
            }
            .distribution(.equalCentering)
            .height(Grid.x60.value)
      }
      .backColor(Design.color.infoSecondary)
      .padding(Asset.Design.params.contentPadding)
      .cornerRadius(Design.params.cornerRadiusSmall)

   lazy var logoutButton = Design.button.default
      .set(Design.state.button.default)
      .title(Design.Text.button.logoutButton)

   private lazy var useCase = Asset.apiUseCase

   override func start() {
      vcModel?
         .title("Настройки")
         .on(\.viewDidLoad, self) { $0.configure() }
   }

   func configure() {
      mainVM.bodyStack
         .arrangedModels([
            organizationsModel,
            Spacer(16),
//            general,
//            Spacer(8),
//            help,
//            Spacer(16),
            logoutButton,
            Grid.xxx.spacer,
         ])

      logoutButton
         .on(\.didTap)
         .doNext(useCase.logout)
         .onSuccess(self) { slf, _ in
            slf.dismiss()
            UserDefaults.standard.setIsLoggedIn(value: false)
            guard
               let userId = slf.inputValue?.profile.id,
               let deviceId = UIDevice.current.identifierForVendor?.uuidString
            else { return }
            let request = RemoveFcmToken(device: deviceId, userId: userId)
            slf.useCase.removeFcmToken
               .doAsync(request)
               .onSuccess {
                  print("success")
               }
               .onFail {
                  print("fail")
               }
            Asset.router?.route(.presentInitial, scene: \.digitalThanks, payload: ())
         }.onFail {
            print("logout api failed")
         }

      loadOrganizations()
   }
}

extension SettingsScene {
   private func loadOrganizations() {
      guard let currentOrg = inputValue?.profile.organization else {
         assertionFailure("no current organization"); return
      }

      useCase.getUserOrganizations
         .doAsync()
         .onSuccess(self) { slf, organizations in
            slf.organizationsModel.setup((currentOrg: currentOrg, orgs: organizations))
            slf.organizationsModel.on(\.didSelectOrganizationIndex) { index in
               let id = organizations[index].id
               self.useCase.changeOrganization
                  .doAsync(id)
                  .onSuccess {
                     print($0)
                     let authResult = AuthResult(xId: $0.xId,
                                                 xCode: $0.xCode,
                                                 account: $0.account,
                                                 organizationId: $0.organizationId)

                     Asset.router?.route(.presentInitial, scene: \.verify, payload: authResult)
                  }
                  .onFail {
                     print("fail")
                  }
            }
         }
   }
}
