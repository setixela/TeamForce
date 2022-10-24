//
//  GetFeedUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.08.2022.
//

import Foundation
import ReactiveWorks

struct GetFeedUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getFeedsApiWorker: GetFeedsApiWorker

   var work: Work<Pagination, [Feed]> {
      Work<Pagination, [Feed]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               return ($0, input)
            }
            .doNext(worker: getFeedsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
