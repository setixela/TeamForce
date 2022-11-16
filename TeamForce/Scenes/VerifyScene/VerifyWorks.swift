//
//  VerifyWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import Foundation
import ReactiveWorks
import UIKit

protocol VerifyBackstageProtocol: Assetable {
   var verifyCode: VoidWork<VerifyResultBody> { get }
   var smsCodeInputParse: Work<String, String> { get }
   var saveLoginResults: Work<VerifyResultBody, Void> { get }
}

final class VerifyWorks<Asset: AssetProtocol>: BaseSceneWorks<VerifyWorks.Temp, Asset>, VerifyBackstageProtocol {
   //
   private lazy var useCase = Asset.apiUseCase

   private lazy var smsParser = SmsCodeCheckerModel()

   // Temp Storage
   final class Temp: InitProtocol {
      var smsCodeInput: String?
      var authResult: AuthResult?
   }

   // MARK: - Works

   var saveInput: Work<AuthResult, Void> { .init { work in
      guard let input = work.input else { work.fail(); return }
      Self.store.authResult = input
      work.success()
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
         smsCode: inputCode,
         organizationId: authResult.organizationId
      )
      guard let isNumber = authResult.organizationId?.isNumber else {
         work.fail()
         return
      }
      if isNumber == true {
         self?.useCase.verifyCode
            .doAsync(request)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      } else {
         self?.useCase.changeOrgVerifyCode
            .doAsync(request)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
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
