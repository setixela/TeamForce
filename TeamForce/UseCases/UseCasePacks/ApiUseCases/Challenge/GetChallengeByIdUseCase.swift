//
//  GetChallengeByIdUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import ReactiveWorks

struct GetChallengeByIdUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getChallengeByIdApiWorker: GetChallengeByIdApiWorker

   var work: Work<Int, Challenge> {
      Work<Int, Challenge>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: getChallengeByIdApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
