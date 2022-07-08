//
//  VerifyCodeScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

import RealmSwift

class Token: Object, SingleObject {
   @Persisted var token: String

   static let uniqueKey: String = "Token"

   @Persisted var uniqueKey: String = Token.uniqueKey

   override static func primaryKey() -> String? {
      "uniqueKey"
   }
}

protocol SingleObject: Object {
   static var uniqueKey: String  { get }
}

extension SingleObject {
   var uniqueKey: Persisted<String> { Persisted(wrappedValue: Self.uniqueKey) }

   static func primaryKey() -> String? {
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

   private lazy var verifyApi = VerifyApiModel(apiEngine: Asset.service.apiEngine)
   private var smsCode: String?

   private lazy var safeStringStorage = TokenStorageModel(engine: Asset.service.safeStringStorage)

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
               .onEvent(\.success) { result in
                  let fullToken = "Token " + result.token
                  let csrfToken = result.sessionId

                  weakSelf?.safeStringStorage.sendEvent(\.saveValue, (value: fullToken, key: "token"))
                  weakSelf?.safeStringStorage.sendEvent(\.saveValue, (value: csrfToken, key: "csrftoken"))
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

protocol StorageEventProtocol: InitProtocol, Associated {
   var saveValue: Event<AsType>? { get set }
   var requestValue: Event<Void>? { get set }
   var responseValue: Event<AsType>? { get set }
}

struct StorageStringEvent: InitProtocol {
   var saveValue: Event<(value: String, key: String)>?
   var requestValue: Event<String>?
   var responseValue: Event<String>?
}

final class TokenStorageModel: BaseModel, Communicable {
   var eventsStore = StorageStringEvent()

   private var storageEngine: StringStorage?

   convenience init(engine: StringStorage) {
      self.init()

      storageEngine = engine
   }

   override func start() {
      onEvent(\.requestValue) { [weak self] key in

         guard let token = self?.storageEngine?.load(forKey: key) else {
            print("\nNo value for key: \(key)\n")
            return
         }

         self?.sendEvent(\.responseValue, token)
      }
      onEvent(\.saveValue) { [weak self] keyValue in
         self?.storageEngine?.save(keyValue.value, forKey: keyValue.key)
      }
   }
}

protocol StringStorageProtocol {
   func saveString(_ value: String)
   func getString() -> String?
}

protocol StringStorage {
   func save(_ value: String, forKey key: String)
   func load(forKey key: String) -> String?
}

import SwiftKeychainWrapper

struct KeyChainStore: StringStorage {
   func save(_ value: String, forKey key: String) {
      KeychainWrapper.standard.set(value, forKey: key)
   }

   func load(forKey key: String) -> String? {
      KeychainWrapper.standard.string(forKey: key)
   }
}

struct TokenRealmStorage: StringStorageProtocol {
   func saveString(_ value: String) {
      let realm = try? Realm()
      let realmToken = Token()
      realmToken.token = value

      print("TOKEN:\n\(value)\n")

      try? realm?.write {
         realm?.add(realmToken, update: .all)
      }
   }

   func getString() -> String? {
      guard
         let realm = try? Realm(),
         let token = realm.objects(Token.self).first
      else {
         return nil
      }

      return token.token
   }
}

// struct DataBaseEngine {
//   func save() {
//      let realm = try Realm()
//      let realmToken = Token()
//      realmToken.token = "Token " + result.token
//
//      print("TOKEN:\n\(result.token)\n")
//
//      try realm.write {
//         realm.add(realmToken, update: .all)
//      }
//   }
// }
