//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - LoginScene

// protocol LoginUseCase {}

//class LoginUseCases<Asset: AssetProtocol> {
//
//   private let inputParser = TelegramNickCheckerModel()
//   private let apiModel = AuthApiModel(apiEngine: Asset.service.apiEngine)
//
//   private var loginName: String?
//
//   func onNextButtonTryLogin() {
//      nextButton
//         .onEvent(\.didTap) {
//            guard let loginName = self.loginName else { return }
//
//            self.apiModel
//               .doAsync(loginName)
//               .onSuccess {
//                  Asset.router?.route(\.verifyCode, navType: .push, payload: $0)
//               }
//               .onFail {
//                  self.badgeModel.changeState(to: BadgeState.error)
//               }
//         }
//   }
//}

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

      nextButton
         .onEvent(\.didTap) { [weak self] in
            guard let loginName = self?.loginName else { return }

            self?.apiModel
               .doAsync(loginName)
               .onSuccess {
                  Asset.router?.route(\.verifyCode, navType: .push, payload: $0)
               }
               .onFail {
                  self?.badgeModel.changeState(to: BadgeState.error)
               }
         }

      badgeModel.textFieldModel
         .onEvent(\.didEditingChanged) { [weak self] text in
            self?.inputParser
               .doAsync(text)
               .onSuccess { text in
                  self?.loginName = String(text.dropFirst())
                  self?.badgeModel.textFieldModel.set(.text(text))
                  self?.nextButton.set(Design.State.button.default)
                  self?.badgeModel.changeState(to: BadgeState.default)
               }
               .onFail { (text: String) in
                  self?.loginName = nil
                  self?.badgeModel.textFieldModel.set(.text(text))
                  self?.nextButton.set(Design.State.button.inactive)
                  self?.badgeModel.changeState(to: BadgeState.default)
               }
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
            badgeModel,
            Spacer(),
            nextButton
         ]))
   }
}
