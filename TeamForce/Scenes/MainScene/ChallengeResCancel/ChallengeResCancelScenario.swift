//
//  ChallengeResCancelScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 17.10.2022.
//

import ReactiveWorks

struct ChallengeResCancelEvents {
   let saveInput: VoidWork<Int>
   let commentInputChanged: VoidWork<String>
   let sendReject: VoidWork<Void>
}

final class ChallengeResCancelScenario<Asset: AssetProtocol>: BaseScenario<ChallengeResCancelEvents, ChallengeResCancelSceneState, ChallengeResCancelWorks<Asset>> {

   override func start() {
      events.commentInputChanged
         .doNext(works.reasonInputParsing)
         .onSuccess(setState, .sendingEnabled)
         .onFail(setState, .sendingDisabled)
      
      events.saveInput
         .doNext(works.saveInput)
      
      events.sendReject
         .doNext(works.rejectReport)
         .onSuccess(setState, .finish)
         .onFail {
            print("Обработать ошибку")
         }
      
   }
}

