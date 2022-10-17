//
//  GetTransactionStatisticsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 21.09.2022.
//

import ReactiveWorks

struct GetTransactionStatisticsUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getTransactionStatisticsApiWorker: GetTransactionStatisticsApiWorker

   var work: Work<TransactStatRequest, TransactStatistics> {
      Work<TransactStatRequest, TransactStatistics>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = TransactStatRequest(token: $0,
                                                 transactionId: input.transactionId)
               return request
            }
            .doNext(worker: getTransactionStatisticsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
