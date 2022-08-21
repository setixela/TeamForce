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
      // setup input field reactions
      events.userNameStringEvent
         .doNext(work: works.loginNameInputParse)
         .onSuccess(setState) { .nameInputParseSuccess($0) }
         .onFail(setState) { .smsInputParseError($0) }

      // setup get code button reaction
      events.getCodeButtonEvent
         .doNext(work: works.authByName)
         .onSuccess(setState, .inputSmsCode)

7
   }
}
