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
      LoginWorks<Asset>
   >
{
   override func start() {
      // setup input field reactions
      events.userNameStringEvent
         .doNext(work: works.loginNameInputParse)
         .onSuccess(setState) { .nameInputParseSuccess($0) }
         .onFail(setState) { .nameInputParseError($0) }

      // setup get code button reaction
      events.getCodeButtonEvent
         .doNext(work: works.authByName)
         .onSuccess(setState, .inputSmsCode)

      // setup input field reactions
      events.smsCodeStringEvent
         //
         .doNext(work: works.smsCodeInputParse)
         .onSuccess(setState) { .smsInputParseSuccess($0) }
         .onFail(setState) { .smsInputParseError($0) }

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
