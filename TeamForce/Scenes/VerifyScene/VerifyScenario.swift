//
//  VerifyScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import ReactiveWorks

struct VerifyScenarioEvents {
   let saveInput: VoidWork<AuthResult>
   let smsCodeStringEvent: VoidWork<String>
   let loginButtonEvent: VoidWork<Void>
}

final class VerifyScenario<Asset: AssetProtocol>:
   BaseScenario<
      VerifyScenarioEvents,
      VerifySceneState,
      VerifyWorks<Asset>
   >
{
   override func start() {
      events.saveInput
         .doNext(works.saveInput)
         .onSuccess {
            print("success")
         }
         .onFail {
            print("fail")
         }
      // setup input field reactions
      events.smsCodeStringEvent
         //
         .doNext(works.smsCodeInputParse)
         .onSuccess(setState) { .smsInputParseSuccess($0) }
         .onFail(setState) { .smsInputParseError($0) }

      // setup login button reactions
      events.loginButtonEvent
         .onSuccess(setState, .startActivityIndicator)
         //
         .doNext(works.verifyCode)
         .onFail(setState, .invalidSmsCode)
         .doNext(works.saveLoginResults)
         .onSuccess {
            Asset.router?.route(.presentInitial, scene: \.main, payload: ())
         }
         .doNext(works.setFcmToken)
//         .onSuccess {
//            print("success")
//         }
//         .onFail {
//            print("fail")
//         }
   }
}
