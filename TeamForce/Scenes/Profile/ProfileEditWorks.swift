//
//  ProfileEditWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks

protocol ProfileEditWorksProtocol: Assetable {
//   var authByName: VoidWork<AuthResult> { get }
//   var verifyCode: VoidWork<VerifyResultBody> { get }
//
//   var loginNameInputParse: Work<String, String> { get }
//   var smsCodeInputParse: Work<String, String> { get }
//
//   var saveLoginResults: Work<VerifyResultBody, Void> { get }
}

final class ProfileEditWorks<Asset: AssetProtocol>: BaseSceneWorks<ProfileEditWorks.Temp, Asset>, ProfileEditWorksProtocol {
   //
   private lazy var useCase = Asset.apiUseCase

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
            work.fail(())
         }
   }}


   var updateContact: Work<(Int, String), Void> { .init { [weak self] work in
      self?.useCase.updateContact
         .doAsync(work.input)
         .onSuccess {
            print("I am success")
         }
         .onFail {
            print("I am fail")
         }
   }}

}
