//
//  GetTransactionsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 04.08.2022.
//

import Foundation
import ReactiveWorks


struct GetTransactionsUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getTransactionsApiWorker: GetTransactionsApiWorker

   var work: Work<Void, [Transaction]> {
      Work<Void, [Transaction]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }
            .doNext(worker: getTransactionsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
