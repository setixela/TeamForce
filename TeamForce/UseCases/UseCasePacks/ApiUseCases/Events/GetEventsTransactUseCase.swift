//
//  GetEventsTransactUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 25.10.2022.
//

import Foundation
import ReactiveWorks

struct GetEventsTransactUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getEventsTransactApiWorker: GetEventsTransactApiWorker

   var work: Work<Pagination, [FeedElement]> {
      Work<Pagination, [FeedElement]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               return ($0, input)
            }
            .doNext(worker: getEventsTransactApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
