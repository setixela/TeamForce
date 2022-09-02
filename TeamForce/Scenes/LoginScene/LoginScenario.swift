//
//  LoginScenery.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

typealias VoidWork<T> = Work<Void, T>
typealias VoidWorkVoid = Work<Void, Void>

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
         .onSuccess(setState, .startActivityIndicator)
         .doNext(work: works.authByName)
         .onSuccess(setState, .inputSmsCode)
         .onFail(setState, .invalidUserName)

      // setup input field reactions
      events.smsCodeStringEvent
         //
         .doNext(work: works.smsCodeInputParse)
         .onSuccess(setState) { .smsInputParseSuccess($0) }
         .onFail(setState) { .smsInputParseError($0) }

      // setup login button reactions
      events.loginButtonEvent
         .onSuccess(setState, .startActivityIndicator)
         //
         .doNext(work: works.verifyCode)
         .onFail(setState, .invalidSmsCode)
         .doNext(work: works.saveLoginResults)
         .onSuccess {
            Asset.router?.route(\.main, navType: .presentInitial, payload: ())
         }
   }
}
