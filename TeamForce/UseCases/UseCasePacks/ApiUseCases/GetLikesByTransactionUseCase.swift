//
//  GetLikesByTransactionUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 04.10.2022.
//

import ReactiveWorks

struct GetLikesByTransactionUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getLikesByTransactionApiWorker: GetLikesByTransactionApiWorker

   var work: Work<LikesByTransactRequest, [Like]> {
      Work<LikesByTransactRequest, [Like]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = LikesByTransactRequest(token: $0,
                                                    body: input.body)
               return request
            }
            .doNext(worker: getLikesByTransactionApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
