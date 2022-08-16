//
//  LoginWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import Foundation
import ReactiveWorks

protocol LoginWorksProtocol {
   var authByName: Work<Void, AuthResult> { get }
   var verifyCode: Work<Void, VerifyResultBody> { get }

   var loginNameInputParse: Work<String, String> { get }
   var smsCodeInputParse: Work<String, String> { get }

   var saveLoginResults: Work<VerifyResultBody, Void> { get }
}

final class LoginWorks<Asset: AssetProtocol>: BaseSceneWorks<LoginWorks.Temp, Asset>, LoginWorksProtocol {
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

   lazy var authByName = Work<Void, AuthResult> { [weak self] work in
      self?.useCase.login.work
         .doAsync(Self.store.loginName)
         .doAsync()
         .onSuccess {
            Self.store.authResult = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail(())
         }
         .retainBy(self?.retainer)
   }

   lazy var verifyCode = Work<Void, VerifyResultBody> { [weak self] work in

      guard
         let inputCode = Self.store.smsCodeInput,
         let authResult = Self.store.authResult
      else {
         work.fail(())
         return
      }

      let request = VerifyRequest(
         xId: authResult.xId,
         xCode: authResult.xCode,
         smsCode: inputCode)

      self?.useCase.verifyCode.work
         .retainBy(self?.retainer)
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail(())
         }
   }

   lazy var loginNameInputParse = Work<String, String> { [weak self] work in
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
   }

   lazy var smsCodeInputParse = Work<String, String> { [weak self] work in
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
   }

   lazy var saveLoginResults = Work<VerifyResultBody, Void> { [weak self] work in

      self?.useCase.safeStringStorage
         .set(.save((value: work.unsafeInput.token, key: "token")))
         .set(.save((value: work.unsafeInput.sessionId, key: "csrftoken")))

      UserDefaults.standard.setIsLoggedIn(value: true)

      work.success(result: ())
   }
}
