//
//  LoginScenery.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

typealias WorkVoid<T> = Work<Void, T>
typealias WorkVoidVoid = Work<Void, Void>

struct LoginScenarioEvents {
   let userNameStringEvent: WorkVoid<String>
   let smsCodeStringEvent: WorkVoid<String>
   let getCodeButtonEvent: WorkVoid<Void>
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
         .onSuccess(setState){
            switch $0 {
            case .auth(let value):
               return .routeAuth(value)
            case .organisations(let value):
               return .routeOrganizations(value)
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
