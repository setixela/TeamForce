//
//  LoadBalanceUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation

struct LoadBalanceUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let balanceApiModel: GetBalanceApiWorker

   func work() -> Work<Void, Balance> {
      Work<Void, Balance>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }
            .doNext(worker: balanceApiModel)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail(())
            }
      }
   }
}