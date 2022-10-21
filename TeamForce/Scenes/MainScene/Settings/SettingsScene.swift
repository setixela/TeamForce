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
   StackModel,
   Asset,
   Void
> {
   // MARK: - Frame Cells

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
      vcModel?.on(\.viewDidLoad, self) { $0.configure() }
   }

   func configure() {
      mainVM
         .axis(.vertical)
         .distribution(.fill)
         .alignment(.fill)
         .arrangedModels([
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
         .onSuccess {
            UserDefaults.standard.setIsLoggedIn(value: false)
            Asset.router?.route(.presentInitial, scene: \.digitalThanks, payload: ())
         }.onFail {
            print("logout api failed")
         }
   }
}
