//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - LoginScene

final class LoginScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   Void
> {
   // MARK: - View Models

   private let coverViewModel = CoverViewModel<Asset>()
      .set(.backImage(Design.icon.make(\.loginBackground)))

   private let headerModel = Design.label.headline4
      .set(.padding(.init(top: 12, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.make(\.enter)))

   private let subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 32, right: 0)))
      .set(.text(Text.title.make(\.enterTelegramName)))
      .set(.numberOfLines(2))

   private let nextButton = Design.button.inactive
      .set(.title(Text.button.make(\.getCodeButton)))

   private let badgeModel = BadgeModel<Asset>()
   // MARK: - Services

   private let inputParser = TelegramNickCheckerModel()
   private let apiModel = AuthApiModel(apiEngine: Asset.service.apiEngine)

   private var loginName: String?

   // MARK: - Start

   override func start() {
      configure()
      badgeModel.setLabels(title: Text.title.make(\.userName),
                           placeholder: "@" + Text.title.make(\.userName),
                           error: Text.title.make(\.wrongUsername))

      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            guard let loginName = weakSelf?.loginName else { return }

            weakSelf?.apiModel
               .onEvent(\.success) { authResult in
                  Asset.router?.route(\.verifyCode, navType: .push, payload: authResult)
               }
               .onEvent(\.error) { error in
                  print("\n", error.localizedDescription)
                  weakSelf?.badgeModel.changeState(to: BadgeState.error)
               }
               .sendEvent(\.request, loginName)
         }

      badgeModel.textFieldModel
         .onEvent(\.didEditingChanged) { text in
            weakSelf?.inputParser.sendEvent(\.request, text)
            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
      
      inputParser
         .onEvent(\.success) { text in
            weakSelf?.loginName = String(text.dropFirst())
            weakSelf?.badgeModel.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.State.button.default)
            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .onEvent(\.error) { text in
            weakSelf?.loginName = nil
            weakSelf?.badgeModel.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.State.button.inactive)
         }
   }

   private func configure() {
      mainViewModel
         .set(.backColor(Design.color.background2))

      mainViewModel.topStackModel
         .set(.models([
            coverViewModel
         ]))

      mainViewModel.bottomStackModel
         .set(Design.State.mainView.default)
         .set(.models([
            headerModel,
            subtitleModel,
            textFieldModel,
            Spacer(),
            nextButton
         ]))
   }
}
