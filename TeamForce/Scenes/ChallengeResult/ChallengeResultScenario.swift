//
//  ChallengeResultScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.10.2022.
//

import ReactiveWorks

struct ChallengeResultEvents {
   let saveInput: WorkVoid<Int>
   let commentInputChanged: WorkVoid<String>
   let sendResult: WorkVoid<Void>
}

final class ChallengeResultScenario<Asset: AssetProtocol>: BaseScenario<ChallengeResultEvents, ChallengeResultSceneState, ChallengeResultWorks<Asset>> {

   override func start() {
      events.commentInputChanged
         .doNext(works.reasonInputParsing)
         .onSuccess(setState, .sendingEnabled)
         .onFail(setState, .sendingDisabled)
      
      events.saveInput
         .doNext(works.saveId)
      
      events.sendResult
         .onSuccess(setState, .sendingDisabled)
         .doNext(works.createChallengeReport)
         .onSuccess(setState) { .finish }
         .onFail {
            print("Обработать ошибку")
         }
//         .onSuccess(setState, .popScene)
//         .doNext(works.createChallengeReport)
//         .onSuccess(setState, .resultSent)
//         .onFail {
//            print("Обработать ошибку")
//         }
   }
}

