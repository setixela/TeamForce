//
//  GetCurrentPeriodUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 19.08.2022.
//

import Foundation
import ReactiveWorks

struct GetCurrentPeriodUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getCurrentPeriodApiWorker: GetCurrentPeriodApiWorker

   var work: Work<Void, Period> {
      Work<Void, Period>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doNext(worker: getCurrentPeriodApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
