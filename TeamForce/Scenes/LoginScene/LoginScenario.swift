//
//  LoginScenery.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

struct LoginSceneryCase: SceneModeProtocol {
   var inputUserName: VoidEvent?
   var inputSmsCode: VoidEvent?
}

final class LoginScenario<Asset: AssetProtocol>: BaseScenario<LoginViewModels<Asset>, LoginWorks<Asset>>
{
   var modes: LoginSceneryCase = .init()

   override func start() {
      let works = works
      let vModels = vModels

      // setup input field reactions
      vModels.userNameInputModel.textField
         .onEvent(\.didEditingChanged)
         .onSuccess {
           //weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .doNext(work: works.loginNameInputParse)
         .onSuccess {
            vModels.setMode(.nameInputParseSuccess($0))
         }
         .onFail { (text: String) in
            vModels.setMode(.smsInputParseError(text))
         }

      // setup get code button reaction
      vModels.getCodeButton
         .onEvent(\.didTap)
         .doNext(work: works.authByName)
         .onSuccess {
            vModels.setMode(.inputSmsCode)
         }
         .onFail {
            vModels.setMode(.inputUserName)
         }

      // setup input field reactions
      vModels.smsCodeInputModel.textField
         //
         .onEvent(\.didEditingChanged)
         //
         .doNext(work: works.smsCodeInputParse)
         .onSuccess {
            vModels.setMode(.smsInputParseSuccess($0))
         }.onFail { (text: String) in
            vModels.setMode(.smsInputParseError(text))
         }

      // setup login button reactions
      vModels.loginButton
         //
         .onEvent(\.didTap)
         //
         .doNext(work: works.verifyCode)
         .onFail {
            print("Verify api error")
         }
         .doNext(work: works.saveLoginResults)
         .onSuccess {
            Asset.router?.route(\.main, navType: .present, payload: ())
         }
         .onFail {
            print("Save login results to persistence error")
         }
   }
}
