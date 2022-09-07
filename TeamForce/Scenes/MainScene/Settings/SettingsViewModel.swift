//
//  SettingsViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 22.08.2022.
//

import ReactiveWorks
import UIKit

struct SettingsViewEvent: InitProtocol {}


final class SettingsViewModel<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState
   var events: SettingsViewEvent = .init()

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
      set(.axis(.vertical))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set(.arrangedModels([
         general,
         Spacer(8),
         help,
         Spacer(16),
         logoutButton,
         Grid.xxx.spacer,
      ]))

      logoutButton
         .on(\.didTap)
         .doNext(work: useCase.logout)
         .onSuccess {
            UserDefaults.standard.setIsLoggedIn(value: false)
            Asset.router?.route(\.digitalThanks, navType: .presentInitial, payload: ())
         }.onFail {
            print("logout api failed")
         }
   }
}
