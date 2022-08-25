//
//  CancelTransactionByIdUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import Foundation
import ReactiveWorks

struct CancelTransactionByIdUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let cancelTransactionByIdApiWorker: CancelTransactionByIdApiWorker
   
   var work: Work<Int, Void> {
      Work<Int, Void> { work in
         safeStringStorage
            .doAsync("token") // TODO: - Token key input
            .onFail {
               work.fail(()) // TODO: - Error
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: cancelTransactionByIdApiWorker)
            .onSuccess {
               work.success(result: ())
            }
            .onFail {
               work.fail(()) // TODO: - Error
            }
      }
   }
}
