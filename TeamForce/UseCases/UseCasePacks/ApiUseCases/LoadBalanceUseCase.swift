//
//  LoadBalanceUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct LoadBalanceUseCase: UseCaseProtocol {
   let loadToken: LoadTokenUseCase.WRK
   let balanceApiModel: GetBalanceApiWorker

   var work: Work<Void, Balance> { .init { work in
      //
      loadToken
         .doAsync()
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
   } }
}
