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
      .set(.image(Icons().make(\.digitalThanksLogo)))
      .set(.contentMode(.scaleAspectFit))
   
   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text(text.title.make(\.enter)))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("2. " + text.title.make(\.enterSmsCode)))
      .set(.numberOfLines(2))

   private lazy var enterButton = ButtonModel(Design.State.button.inactive)
      .set(.title(text.button.make(\.enterButton)))

   private lazy var textFieldModel = TextFieldModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder(text.title.make(\.smsCode)))
      .set(.backColor(UIColor.clear))
      .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
      .set(.borderWidth(1.0))

   private lazy var inputParser = SmsCodeCheckerModel()

   private lazy var verifyApi = VerifyApiModel(apiEngine: Asset.service.apiEngine)
   private var smsCode: String?

   private lazy var safeStringStorage = StringStorageModel(engine: Asset.service.safeStringStorage)

   // MARK: - Start

   override func start() {
//      configure()

      weak var weakSelf = self

      vcModel?
         .onEvent(\.viewDidLoad) {
            weakSelf?.configure()
         }
      
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
               }
               .onEvent(\.error) { error in
                  print(error)
               }
               .sendEvent(\.request, verifyRequest)
         }

      textFieldModel
         .onEvent(\.didEditingChanged) {
            weakSelf?.inputParser.sendEvent(\.request, $0)
         }

      inputParser
         .onEvent(\.success) {
            weakSelf?.smsCode = $0
            weakSelf?.textFieldModel.set(.text($0))
            weakSelf?.enterButton.set(Design.State.button.default)
         }
         .onEvent(\.error) {
            weakSelf?.smsCode = nil
            weakSelf?.textFieldModel.set(.text($0))
            weakSelf?.enterButton.set(Design.State.button.inactive)
         }
   }

   private func configure() {
      mainViewModel.setupBackgroundImage(name: "background_vector_1.png")
      
      mainViewModel
         .set(.backColor(Design.color.background2))
         .set(Design.State.mainView.default)
         .set(.topModels([
            Spacer(size: 100),
            logoImage,
            Spacer(size: 300),
            headerModel,
            subtitleModel,
            Spacer(size: 16),
            textFieldModel,
            Spacer()
         ]))
         .set(.bottomModels([
            enterButton
         ]))
   }
}
