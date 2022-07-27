//
//  VerifyCodeScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - VerifyCodeScene

final class VerifyCodeScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   AuthResult
> {
   //
   private lazy var logoImage = ImageViewModel()
      .set(.size(.init(width: 65, height: 65)))
      .set(.image(Design.icon.make(\.digitalThanksLogo)))
      .set(.contentMode(.scaleAspectFit))
   
   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.make(\.enter)))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("2. " + Text.title.make(\.enterSmsCode)))
      .set(.numberOfLines(2))

   private lazy var enterButton = ButtonModel(Design.State.button.inactive)
      .set(.title(Text.button.make(\.enterButton)))

   private let badgeModel = BadgeModel<Asset>()

   private lazy var inputParser = SmsCodeCheckerModel()

   private lazy var verifyApi = VerifyApiModel(apiEngine: Asset.service.apiEngine)
   private var smsCode: String?

   private lazy var safeStringStorage = StringStorageModel(engine: Asset.service.safeStringStorage)

   // MARK: - Start

   override func start() {
      configure()

      badgeModel.setLabels(title: Text.title.make(\.smsCode),
                           placeholder: Text.title.make(\.smsCode),
                           error: Text.title.make(\.wrongCode))
      
      weak var weakSelf = self
      
      enterButton
         .onEvent(\.didTap) {
            guard
               let authResult = weakSelf?.inputValue,
               let smsCode = weakSelf?.smsCode
            else { return }

            let verifyRequest = VerifyRequest(xId: authResult.xId, xCode: authResult.xCode, smsCode: smsCode)
            weakSelf?.verifyApi
               .onEvent(\.success) { result in
                  let fullToken = "Token " + result.token
                  let csrfToken = result.sessionId

                  weakSelf?.safeStringStorage.sendEvent(\.saveValueForKey, (value: fullToken, key: "token"))
                  weakSelf?.safeStringStorage.sendEvent(\.saveValueForKey, (value: csrfToken, key: "csrftoken"))

                  Asset.router?.route(\.loginSuccess, navType: .push, payload: fullToken)
                  
                  UserDefaults.standard.setIsLoggedIn(value: true)
               }
               .onEvent(\.error) { error in
                  print(error)
                  weakSelf?.badgeModel.changeState(to: BadgeState.error)
               }
               .sendEvent(\.request, verifyRequest)
         }

      badgeModel.textFieldModel
         .onEvent(\.didEditingChanged) {
            weakSelf?.inputParser.sendEvent(\.request, $0)
            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }

      inputParser
         .onEvent(\.success) {
            weakSelf?.smsCode = $0
            weakSelf?.badgeModel.textFieldModel.set(.text($0))
            weakSelf?.enterButton.set(Design.State.button.default)
         }
         .onEvent(\.error) {
            weakSelf?.smsCode = nil
            weakSelf?.badgeModel.textFieldModel.set(.text($0))
            weakSelf?.enterButton.set(Design.State.button.inactive)
         }
   }

   private func configure() {
      
      mainViewModel
         .set(.backColor(Design.color.background2))
         .set(Design.State.mainView.default)

      mainViewModel.topStackModel
         .set(.models([
            Spacer(size: 100),
            headerModel,
            subtitleModel,
            Spacer(size: 16),
            badgeModel,
            Spacer()
         ]))
      
      mainViewModel.bottomStackModel
         .set(.models([
            enterButton
         ]))
   }
}
