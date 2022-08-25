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

   var work: Work<Void, [Feed]> {
      Work<Void, [Feed]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }
            .doNext(worker: getFeedsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
