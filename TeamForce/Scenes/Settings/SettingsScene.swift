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
   ModalDoubleStackModel<Asset>,
   Asset,
   Int
> {
   // MARK: - Frame Cells

   private lazy var organizationsModel = ChangeOrganizationModel<Design>()

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
      mainVM.closeButton.on(\.didTap, self) { $0.dismiss() }
      vcModel?.on(\.viewDidLoad, self) { $0.configure() }
   }

   func configure() {
      mainVM.bodyStack
         .arrangedModels([
            organizationsModel,
            Spacer(16),
            general,
            Spacer(8),
            help,
            Spacer(16),
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
               let userId = slf.inputValue,
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
      useCase.getUserOrganizations
         .doAsync()
         .onSuccess(self) {
            $0.organizationsModel.setup($1)
         }
   }
}

final class ChangeOrganizationModel<Design: DSP>: StackModel, Designable {
   private lazy var changeButton = StackModel()
      .backColor(Design.color.backgroundBrandSecondary)
      .cornerRadius(Design.params.cornerRadius)
      .arrangedModels(
         M<LabelModel>.D<LabelModel>.R<ImageViewModel>.Combo()
            .setAll { title, organization, icon in
               title
                  .set(Design.state.label.caption)
                  .text("Текущая организация")
                  .textColor(Design.color.textBrand)
               organization
                  .set(Design.state.label.body1)
               icon
                  .image(Design.icon.arrowDropDownLine)
                  .size(.square(24))
            }
            .padding(Design.params.cellContentPadding)
      )

   private lazy var organizationsTable = TableItemsModel<Design>()
      .set(.presenters([organizationPresenter]))
      .hidden(true)

   override func start() {
      view.on(\.willAppear, self) {
         $0.configure()
      }
   }

   private func configure() {
      arrangedModels(
         changeButton,
         Spacer(8),
         organizationsTable
      )

      changeButton.view.startTapGestureRecognize()
      changeButton.view.on(\.didTap, self) {
         $0.organizationsTable.hidden(!$0.organizationsTable.view.isHidden)
      }
   }

   private var organizationPresenter: Presenter<Organization, StackModel> { .init { work in
      let organization = work.unsafeInput

      let label = LabelModel()
         .text(organization.item.name ?? "")
         .textColor(Design.color.text)
      let icon = ImageViewModel()
         .contentMode(.scaleAspectFill)
         .image(Design.icon.anonAvatar)
         .size(.square(Grid.x36.value))
         .cornerRadius(Grid.x36.value / 2)

      let cell = StackModel()
         .spacing(Grid.x12.value)
         .axis(.horizontal)
         .alignment(.center)
         .arrangedModels([
            icon,
            label,
            Spacer(),
         ])
         .padding(.outline(16))

      work.success(cell)
   }}
}

extension ChangeOrganizationModel: SetupProtocol {
   func setup(_ data: [Organization]) {
      organizationsTable.set(.items(data))
   }
}

// final class OrganizationCell: StackModel {
//   var
//
//   required init() {
//      super.init(isAutoreleaseView: true)
//   }
// }
