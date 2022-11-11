//
//  GetTransactionsByPeriodUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import Foundation
import ReactiveWorks

struct GetTransactionsByPeriodUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getTransactionsByPeriodApiModel: GetTransactionsByPeriodApiWorker
   
   var work: Work<Int, [Transaction]> {
      Work<Int, [Transaction]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: getTransactionsByPeriodApiModel)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
