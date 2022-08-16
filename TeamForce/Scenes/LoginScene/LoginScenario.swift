//
//  LoginScenery.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks


final class LoginScenario<Asset: AssetProtocol>: BaseScenario<LoginViewModels<Asset>, LoginWorks<Asset>>
{

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
            vModels.setState(.nameInputParseSuccess($0))
         }
         .onFail { (text: String) in
            vModels.setState(.smsInputParseError(text))
         }

      // setup get code button reaction
      vModels.getCodeButton
         .onEvent(\.didTap)
         .doNext(work: works.authByName)
         .onSuccess {
            vModels.setState(.inputSmsCode)
         }
         .onFail {
            vModels.setState(.inputUserName)
         }

      // setup input field reactions
      vModels.smsCodeInputModel.textField
         //
         .onEvent(\.didEditingChanged)
         //
         .doNext(work: works.smsCodeInputParse)
         .onSuccess {
            vModels.setState(.smsInputParseSuccess($0))
         }.onFail { (text: String) in
            vModels.setState(.smsInputParseError(text))
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
