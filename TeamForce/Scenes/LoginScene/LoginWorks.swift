//
//  LoginWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import Foundation
import ReactiveWorks

protocol LoginBackstageProtocol: Assetable {
   var authByName: VoidWork<AuthResult> { get }
   var verifyCode: VoidWork<VerifyResultBody> { get }

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
      var authResult: AuthResult?
   }

   // MARK: - Works

   var authByName: VoidWork<AuthResult> { .init { [weak self] work in
      self?.useCase.login
         .doAsync(Self.store.loginName)
         .onSuccess {
            Self.store.authResult = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }}

   var verifyCode: VoidWork<VerifyResultBody> { .init { [weak self] work in

      guard
         let inputCode = Self.store.smsCodeInput,
         let authResult = Self.store.authResult
      else {
         work.fail()
         return
      }

      let request = VerifyRequest(
         xId: authResult.xId,
         xCode: authResult.xCode,
         smsCode: inputCode)

      self?.useCase.verifyCode
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }}

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
}
