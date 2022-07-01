//
//  VerifyCodeScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

import RealmSwift

class Token: Object {
   @Persisted var token: String

   static let uniqueKey: String = "Token"

   @Persisted var uniqueKey: String = Token.uniqueKey

   override static func primaryKey() -> String? {
      "uniqueKey"
   }
}

// MARK: - VerifyCodeScene

final class VerifyCodeScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   AuthResult
> {
   //
   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text(text.title.make(\.enter)))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("2. " + text.title.make(\.enterSmsCode)))
      .set(.numberOfLines(2))

   private lazy var nextButton = ButtonModel(Design.State.button.inactive)
      .set(.title(text.button.make(\.enterButton)))

   private lazy var textFieldModel = TextFieldModel()
   private lazy var inputParser = SmsCodeCheckerModel()

   private lazy var verifyApi = VerifyApiModel()
   private var smsCode: String?

   // MARK: - Start
   
   override func start() {
      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            guard
               let authResult = weakSelf?.inputValue,
               let smsCode = weakSelf?.smsCode
            else { return }

            let verifyRequest = VerifyRequest(xId: authResult.xId, xCode: authResult.xCode, smsCode: smsCode)
            weakSelf?.verifyApi
               .onEvent(\.response) { result in
                  do {
                     let realm = try Realm()
                     let realmToken = Token()
                     realmToken.token = result.token

                     print("TOKEN:\n\(result.token)\n")
   //
                     try realm.write {
                        realm.add(realmToken, update: .all)
                     }

                     Asset.router?.route(\.loginSuccess, navType: .push, payload: result.token)

                  } catch {
                     print(error)
                  }
//                  let realmToken = Token()
//                  realmToken.token = result.token
//
//                  print("TOKEN:\n\(result.token)\n")
////
//                  try? realm?.write {
//                     realm?.add(realmToken, update: .all)
//                  }
//
//                  Asset.router?.route(\.loginSuccess, navType: .push, payload: result.token)
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
         .sendEvent(\.setPlaceholder, text.title.make(\.smsCode))

      inputParser
         .onEvent(\.success) {
            weakSelf?.smsCode = $0
            weakSelf?.textFieldModel.sendEvent(\.setText, $0)
            weakSelf?.nextButton.set(Design.State.button.default)
         }
         .onEvent(\.error) {
            weakSelf?.smsCode = nil
            weakSelf?.textFieldModel.sendEvent(\.setText, $0)
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
