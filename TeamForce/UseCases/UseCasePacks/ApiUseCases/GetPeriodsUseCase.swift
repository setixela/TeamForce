//
//  GetPeriodsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.08.2022.
//

import Foundation
import ReactiveWorks

struct GetPeriodsUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getPeriodsApiWorker: GetPeriodsApiWorker

   var work: Work<Void, [Period]> {
      Work<Void, [Period]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }
            .doNext(worker: getPeriodsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
