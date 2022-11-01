//
//  GetChallengesUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import ReactiveWorks

struct GetChallengesUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getChallengesApiWorker: GetChallengesApiWorker

   var work: Work<ChallengesRequest, [Challenge]> {
      Work<ChallengesRequest, [Challenge]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard
                  let input = work.input
               else {
                  work.fail()
                  return nil
               }
               let request = ChallengesRequest(token: $0,
                                               activeOnly: input.activeOnly, pagination: input.pagination)
               return request
            }
            .doNext(worker: getChallengesApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
