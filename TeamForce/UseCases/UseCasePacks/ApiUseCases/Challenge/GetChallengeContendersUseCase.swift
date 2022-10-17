//
//  GetChallengeContenders.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import ReactiveWorks

struct GetChallengeContendersUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getChallengeContendersApiWorker: GetChallengeContendersApiWorker

   var work: Work<Int, [Contender]> {
      Work<Int, [Contender]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: getChallengeContendersApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
