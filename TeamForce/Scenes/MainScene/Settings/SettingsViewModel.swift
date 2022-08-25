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
            .set_text("Общие")
            .set_color(Design.color.textContrastSecondary)
      } setDown: {
         $0
            .setMain {
               $0
                  .set_text("Язык")
                  .set_color(Design.color.text)
            } setRight: {
               $0
                  .set_text("Русский")
                  .set_color(Design.color.textContrastSecondary)
            }
            .set_height(Grid.x60.value)

      } setDown2: {
         $0
            .setMain {
               $0
                  .set_text("Тема")
                  .set_color(Design.color.text)
            } setRight: {
               $0
                  .set_text("Как в системе")
                  .set_color(Design.color.textContrastSecondary)
            }
            .set_distribution(.equalCentering)
            .set_height(Grid.x60.value)
      }
      .set_backColor(Design.color.infoSecondary)
      .set_padding(Asset.Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadiusSmall)

   lazy var help = Combos<SComboMDD<LabelModel, DoubleLabelHorizontal, DoubleLabelHorizontal>>()
      .setMain { header in
         header
            .set_text("Помощь")
            .set_color(Design.color.textContrastSecondary)
      } setDown: {
         $0
            .setMain {
               $0
                  .set_text("Обратная связь")
                  .set_color(Design.color.text)
            } setRight: {
               $0
                  .set_text(">")
                  .set_color(Design.color.textContrastSecondary)
            }
            .set_height(Grid.x60.value)

      } setDown2: {
         $0
            .setMain {
               $0
                  .set_text("О приложении")
                  .set_color(Design.color.text)
            } setRight: {
               $0
                  .set_text(">")
                  .set_color(Design.color.textContrastSecondary)
            }
            .set_distribution(.equalCentering)
            .set_height(Grid.x60.value)
      }
      .set_backColor(Design.color.infoSecondary)
      .set_padding(Asset.Design.params.contentPadding)
      .set_cornerRadius(Design.params.cornerRadiusSmall)

   lazy var logoutButton = Design.button.default
      .set(Design.state.button.default)
      .set_title(Design.Text.button.logoutButton)

   private lazy var useCase = Asset.apiUseCase

   override func start() {
      set(.axis(.vertical))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set(.models([
         general,
         Spacer(8),
         help,
         Spacer(8),
         logoutButton,
         Grid.xxx.spacer,
      ]))

      logoutButton
         .onEvent(\.didTap)
         .doNext(work: useCase.logout)
         .onSuccess {
            UserDefaults.standard.setIsLoggedIn(value: false)
            Asset.router?.route(\.digitalThanks, navType: .present, payload: ())
         }.onFail {
            print("logout api failed")
         }
   }
}
