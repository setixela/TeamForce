//
//  GetChallengeReportUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.10.2022.
//

import ReactiveWorks

struct GetChallengeReportUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getChallengeReportApiWorker: GetChallengeReportApiWorker

   var work: Work<Int, ChallengeReport> {
      Work<Int, ChallengeReport>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: getChallengeReportApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
