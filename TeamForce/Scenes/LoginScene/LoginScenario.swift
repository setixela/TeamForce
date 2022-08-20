//
//  LoginScenery.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

typealias VoidWork<T> = Work<Void, T>

struct LoginScenarioEvents {
   let userNameStringEvent: VoidWork<String>
   let smsCodeStringEvent: VoidWork<String>
   let getCodeButtonEvent: VoidWork<Void>
   let loginButtonEvent: VoidWork<Void>
}

final class LoginScenario<Asset: AssetProtocol>:
   BaseScenario<
      LoginScenarioEvents,
      LoginSceneState,
      LoginBackstage<Asset>
   >
{
   override func start() {
      weak var slf = self

      // setup input field reactions
      events.userNameStringEvent
         .onSuccess {
            // weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .doNext(work: works.loginNameInputParse)
         .onSuccess {
            slf?.setState(.nameInputParseSuccess($0))
         }
         .onFail { (text: String) in
            slf?.setState(.smsInputParseError(text))
         }

      // setup get code button reaction
      events.getCodeButtonEvent
         .doNext(work: works.authByName)
         .onSuccess {
            slf?.setState(.inputSmsCode)
         }
         .onFail {
            slf?.setState(.inputUserName)
         }

      // setup input field reactions
      events.smsCodeStringEvent
         //
         .doNext(work: works.smsCodeInputParse)
         .onSuccess {
            slf?.setState(.smsInputParseSuccess($0))
         }.onFail { (text: String) in
            slf?.setState(.smsInputParseError(text))
         }

      // setup login button reactions
      events.loginButtonEvent
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
