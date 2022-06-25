//
//  VerifyCodeScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - VerifyCodeScene

final class VerifyCodeScene: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   Void
> {
   //
   private lazy var headerModel = Design.label.headline4
      .set(.padding(UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text("Вход"))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("2. Введите код"))
      .set(.numberOfLines(2))

   private lazy var nextButton = ButtonModel(Design.State.button.inactive)
      .set(.title("ВОЙТИ"))

   private lazy var textFieldModel = TextFieldModel()

   private lazy var inputParser = SmsCodeCheckerModel()

   override func start() {
      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            Asset.router?.route(\.loginSuccess, navType: .push)
         }

      textFieldModel
         .onEvent(\.didEditingChanged) { text in
            weakSelf?.inputParser.sendEvent(\.request, text)
         }
         .sendEvent(\.setPlaceholder, "@Имя пользователя")

      inputParser
         .onEvent(\.response) { text in
            weakSelf?.textFieldModel.sendEvent(\.setText, text)
            weakSelf?.nextButton.set(Design.State.button.default)
         }
         .onEvent(\.error) { text in
            weakSelf?.textFieldModel.sendEvent(\.setText, text)
            weakSelf?.nextButton.set(Design.State.button.inactive)
         }

      presentModels()
   }

   private func presentModels() {
      mainViewModel
         .sendEvent(\.addViewModels, [
            Spacer(size: 100),
            headerModel,
            subtitleModel,
            Spacer(size: 16),
            textFieldModel,
            Spacer()
         ])
         .sendEvent(\.addBottomPanelModel, nextButton)
   }
}
