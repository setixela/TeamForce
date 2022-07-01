//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - LoginScene

final class LoginScene: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   ProductionAsset,
   Void
> {
   //
   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text("Вход"))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("1. " + text.title.make(\.pressGetCode)))
      .set(.numberOfLines(2))

   private lazy var nextButton = Design.button.inactive
      .set(.title(text.button.make(\.nextButton)))

   private lazy var changeUserButton = Design.button.transparent
      .set(.title(text.button.make(\.changeUserButton)))

   private lazy var textFieldModel = TextFieldModel()
   private lazy var inputParser = TelegramNickCheckerModel()
   private lazy var apiModel = AuthApiModel()

   private var loginName: String?

   // MARK: - Start
   
   override func start() {
      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            guard let loginName = weakSelf?.loginName else { return }

            print(loginName)
            weakSelf?.apiModel
               .onEvent(\.response) { authResult in
                  Asset.router?.route(\.verifyCode, navType: .push, payload: authResult)
               }
               .onEvent(\.error) { error in
                  print("\n", error.localizedDescription)
               }
               .sendEvent(\.request, loginName)
         }

      textFieldModel
         .onEvent(\.didEditingChanged) { text in
            weakSelf?.inputParser.sendEvent(\.request, text)
         }
         .sendEvent(\.setPlaceholder, "@" + text.title.make(\.userName))

      inputParser
         .onEvent(\.success) { text in
            weakSelf?.loginName = String(text.dropFirst())
            weakSelf?.textFieldModel.sendEvent(\.setText, text)
            weakSelf?.nextButton.set(Design.State.button.default)
         }
         .onEvent(\.error) { text in
            weakSelf?.loginName = nil
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
         .bottomModel.sendEvent(\.addModels, [
            nextButton,
            changeUserButton
         ])
   }
}
