//
//  GetStatByPeriodIdUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.08.2022.
//

import Foundation
import ReactiveWorks

struct GetStatByPeriodIdUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getStatByPeriodIdApiWorker: GetStatByPeriodIdApiWorker
   
   var work: Work<Int, PeriodStat> {
      Work<Int, PeriodStat>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: getStatByPeriodIdApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
