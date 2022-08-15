//
//  LoginSceneWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import Foundation
import ReactiveWorks

protocol LoginSceneProtocol {
   var authByName: Work<Void, AuthResult> { get }
   var verifyCode: Work<String, VerifyResultBody> { get }

   var loginNameInputParse: Work<String, String> { get }
}

final class LoginSceneStorage: InitProtocol {
   var loginName: String?
   var smsCodeInput: String?
   var authResult: AuthResult?
}

final class LoginSceneWorks<Asset: AssetProtocol>: BaseSceneWorks<LoginSceneStorage, Asset>, LoginSceneProtocol {
   private lazy var useCase = Asset.apiUseCase
   private lazy var inputParser = TelegramNickCheckerModel()

   // MARK: - Works

   lazy var authByName = Work<Void, AuthResult> { [weak self] work in
      self?.useCase.login.work
         .doAsync(Self.store.loginName)
         .doAsync()
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail(())
         }
         .retainBy(self?.retainer)
   }

   lazy var verifyCode = Work<String, VerifyResultBody> { [weak self] work in

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
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail(())
         }
         .retainBy(self?.retainer)
   }

   lazy var loginNameInputParse = Work<String, String> { [weak self] work in
      self?.inputParser.work
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
}
