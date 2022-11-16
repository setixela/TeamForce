//
//  LoginWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import Foundation
import ReactiveWorks
import UIKit

protocol LoginBackstageProtocol: Assetable {
   var authByName: VoidWork<Auth2Result> { get }
//   var verifyCode: VoidWork<VerifyResultBody> { get }

   var loginNameInputParse: Work<String, String> { get }
   var smsCodeInputParse: Work<String, String> { get }

   var saveLoginResults: Work<VerifyResultBody, Void> { get }
}

final class LoginWorks<Asset: AssetProtocol>: BaseSceneWorks<LoginWorks.Temp, Asset>, LoginBackstageProtocol {
   //
   private lazy var useCase = Asset.apiUseCase

   private lazy var loginParser = TelegramNickCheckerModel()
   private lazy var smsParser = SmsCodeCheckerModel()

   // Temp Storage
   final class Temp: InitProtocol {
      var loginName: String?
      var smsCodeInput: String?
      var auth2Result: Auth2Result?
   }

   // MARK: - Works

   var authByName: VoidWork<Auth2Result> { .init { [weak self] work in
      self?.useCase.login
         .doAsync(Self.store.loginName)
         .onSuccess {
            Self.store.auth2Result = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }}

//   var verifyCode: VoidWork<VerifyResultBody> { .init { [weak self] work in
//
//      guard
//         let inputCode = Self.store.smsCodeInput,
//         let auth2Result = Self.store.auth2Result
//      else {
//         work.fail()
//         return
//      }
//
//      let request = VerifyRequest(
//         xId: auth2Result.xId,
//         xCode: auth2Result.xCode,
//         smsCode: inputCode)
//
//      self?.useCase.verifyCode
//         .doAsync(request)
//         .onSuccess {
//            work.success(result: $0)
//         }
//         .onFail {
//            work.fail()
//         }
//   }}

   var loginNameInputParse: Work<String, String> { .init { [weak self] work in
      self?.loginParser.work
         .retainBy(self?.retainer)
         .doAsync(work.input)
         .onSuccess {
            Self.store.loginName = $0
            work.success(result: $0)
         }
         .onFail { (text: String) in
            Self.store.loginName = nil
            work.fail(text)
         }
   }}

   var smsCodeInputParse: Work<String, String> { .init { [weak self] work in
      self?.smsParser.work
         .retainBy(self?.retainer)
         .doAsync(work.input)
         .onSuccess {
            Self.store.smsCodeInput = $0
            work.success(result: $0)
         }
         .onFail { (text: String) in
            Self.store.smsCodeInput = nil
            work.fail(text)
         }
   }}

   var saveLoginResults: Work<VerifyResultBody, Void> { .init { [weak self] work in

      self?.useCase.safeStringStorage
         .set(.save((value: work.unsafeInput.token, key: "token")))
         .set(.save((value: work.unsafeInput.sessionId, key: "csrftoken")))

      UserDefaults.standard.setIsLoggedIn(value: true)

      work.success()
   }}
   
   var setFcmToken: Work<Void, Void> { .init { [weak self] work in
      guard
         let deviceId = UIDevice.current.identifierForVendor?.uuidString,
         let currentFcmToken = UserDefaults.standard.string(forKey: "fcmToken")
      else {
         work.fail()
         return
      }

      let devicedToken = (deviceId + Config.urlBase).md5()
      let fcm = FcmToken(token: currentFcmToken, device: devicedToken)

      self?.useCase.setFcmToken
         .doAsync(fcm)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   } }
}
