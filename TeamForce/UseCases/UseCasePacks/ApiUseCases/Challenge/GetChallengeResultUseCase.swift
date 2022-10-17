//
//  GetChallengeResultUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 13.10.2022.
//

import ReactiveWorks


struct GetChallengeResultUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getChallengeResultApiWorker: GetChallengeResultApiWorker

   var work: Work<Int, [ChallengeResult]> {
      Work<Int, [ChallengeResult]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               log("No token")
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: getChallengeResultApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
