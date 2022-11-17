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
//   let loginButtonEvent: VoidWork<Void>
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
         .doNext(works.loginNameInputParse)
         .onSuccess(setState) { .nameInputParseSuccess($0) }
         .onFail(setState) { .nameInputParseError($0) }

      // setup get code button reaction
      events.getCodeButtonEvent
         .onSuccess(setState, .startActivityIndicator)
         .doNext(works.authByName)
         .onSuccess{
            switch $0 {
            case .auth(let value):
               Asset.router?.route(.push, scene: \.verify, payload: value)
            case .organisations(let value):
               Asset.router?.route(.push, scene: \.chooseOrgScene, payload: value)
            }
            
         }
         .onFail(setState, .invalidUserName)

      // setup input field reactions
      events.smsCodeStringEvent
         //
         .doNext(works.smsCodeInputParse)
         .onSuccess(setState) { .smsInputParseSuccess($0) }
         .onFail(setState) { .smsInputParseError($0) }

      // setup login button reactions
//      events.loginButtonEvent
//         .onSuccess(setState, .startActivityIndicator)
//         //
//         .doNext(works.verifyCode)
//         .onFail(setState, .invalidSmsCode)
//         .doNext(works.saveLoginResults)
//         .doNext(works.setFcmToken)
////         .onSuccess {
////            print("success")
////         }
////         .onFail {
////            print("fail")
////         }
//         .onSuccess {
//            Asset.router?.route(.presentInitial, scene: \.main, payload: ())
//         }

   }
}
