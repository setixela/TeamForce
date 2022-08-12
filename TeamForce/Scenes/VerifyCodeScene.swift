//
//  VerifyCodeScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit
import ReactiveWorks

// MARK: - VerifyCodeScene

final class VerifyCodeScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   AuthResult
> {
   //
   private lazy var logoImage = ImageViewModel()
      .set(.size(.init(width: 65, height: 65)))
      .set(.image(Design.icon.make(\.logo)))
      .set(.contentMode(.scaleAspectFit))

   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.enter))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("2. " + Text.title.enterSmsCode))
      .set(.numberOfLines(2))
   private lazy var noCodeLabel = Design.label.subtitle
      .set(.text(Text.title.noCode))
      .set(.color(.blue))
   private lazy var messageModel = Design.label.subtitle
      .set(.numberOfLines(4))
      .set(.hidden(true))

   private lazy var enterButton = ButtonModel(Design.state.button.inactive)
      .set(.title(Text.button.enterButton))

   private let badgeModel = BadgeModel<Asset>()

   // MARK: - Workers

   private lazy var inputParser = SmsCodeCheckerModel()
   private lazy var verifyApi = VerifyApiModel(apiEngine: Asset.service.apiEngine)
   private var smsCode: String?

   private lazy var safeStringStorage = StringStorageWorker(engine: Asset.service.safeStringStorage)

   // MARK: - Start

   override func start() {
      configure()
      noCodeLabel.makeTappable()
      noCodeLabel.onEvent(\.didTap) { [weak self] in
         self?.messageModel.set(.hidden(self?.messageModel.view.isHidden == false))
      }
      
      var messageText = ""
      switch(inputValue?.account) {
      case .email:
         messageText = Text.title.messageEmail
      case .telegram:
         messageText = Text.title.messageTelegram
      case .none:
         messageText = ""
      }
      messageModel
         .set(.text(messageText))
      
      badgeModel.setLabels(title: Text.title.smsCode,
                           placeholder: Text.title.smsCode,
                           error: Text.title.wrongCode)
      badgeModel.changeState(to: BadgeState.default)

      weak var weakSelf = self

      enterButton
         //
         .onEvent(\.didTap)
         //
         .doInput {
            weakSelf?.makeVerifyRequest()
         }
         .onFail {
            print("VerifyRequest init error")
         }
         //
         .doNext(worker: verifyApi)
         .onSuccess { result in
            weakSelf?.completeVerify(result: result)
         }.onFail {
            print("Verify api error")
            weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }

      badgeModel.textFieldModel
         //
         .onEvent(\.didEditingChanged)
         //
         .doNext(worker: inputParser)
         .onSuccess {
            weakSelf?.smsCode = $0
            weakSelf?.badgeModel.textFieldModel.set(.text($0))
            weakSelf?.enterButton.set(Design.state.button.default)
         }.onFail { (text: String) in
            weakSelf?.smsCode = nil
            weakSelf?.badgeModel.textFieldModel.set(.text(text))
            weakSelf?.enterButton.set(Design.state.button.inactive)
         }
   }

   private func configure() {

      mainViewModel
         .set(.backColor(Design.color.background2))
         .set(Design.state.stack.default)

      mainViewModel.topStackModel
         .set(.models([
            Spacer(100),
            headerModel,
            subtitleModel,
            Spacer(16),
            badgeModel,
            Spacer(16),
            noCodeLabel,
            Spacer(8),
            messageModel,
            Spacer()
         ]))

      mainViewModel.bottomStackModel
         .set(.models([
            enterButton
         ]))
   }
}

private extension VerifyCodeScene {
   func makeVerifyRequest() -> VerifyRequest? {
      guard
         let authResult = inputValue,
         let smsCode = smsCode
      else { return nil }

      return VerifyRequest(xId: authResult.xId, xCode: authResult.xCode, smsCode: smsCode)
   }

   func completeVerify(result: VerifyResultBody) {
      let fullToken = "Token " + result.token
      let csrfToken = result.sessionId

      safeStringStorage
         .set(.saveValueForKey((value: fullToken, key: "token")))
         .set(.saveValueForKey((value: csrfToken, key: "csrftoken")))

      Asset.router?.route(\.loginSuccess, navType: .push, payload: fullToken)
      UserDefaults.standard.setIsLoggedIn(value: true)
   }
}
