//
//  GetTransactionStatisticsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 21.09.2022.
//

import ReactiveWorks

struct GetLikesCommentsStatUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getLikesCommentsStatApiWorker: GetLikesCommentsStatApiWorker

   var work: Work<LikesCommentsStatRequest, LikesCommentsStatistics> {
      Work<LikesCommentsStatRequest, LikesCommentsStatistics>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = LikesCommentsStatRequest(token: $0,
                                                      body: input.body)
               return request
            }
            .doNext(worker: getLikesCommentsStatApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
