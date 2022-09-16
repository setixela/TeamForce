//
//  GetPeriodByDateUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 19.08.2022.
//

import Foundation
import ReactiveWorks

struct GetPeriodByDateUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getPeriodByDateApiWorker: GetPeriodByDateApiWorker
   
   var work: Work<String, Period> {
      Work<String, Period>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let date = work.input else { return nil }
               return RequestWithDate(token: $0, date: date)
            }
            .doNext(worker: getPeriodByDateApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
