//
//  GetEventsWinnersUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 25.10.2022.
//

import Foundation
import ReactiveWorks

struct GetEventsWinnersUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getEventsWinnersApiWorker: GetEventsWinnersApiWorker

   var work: Work<Pagination, [NewFeed]> {
      Work<Pagination, [NewFeed]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               return ($0, input)
            }
            .doNext(worker: getEventsWinnersApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
