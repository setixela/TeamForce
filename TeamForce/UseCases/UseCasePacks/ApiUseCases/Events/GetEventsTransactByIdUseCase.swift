//
//  GetEventsTransactByIdUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 25.10.2022.
//

import ReactiveWorks

struct GetEventsTransactByIdUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getEventsTransactByIdApiModel: GetEventsTransactByIdApiWorker
   
   var work: Work<Int, EventTransaction> {
      Work<Int, EventTransaction>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: getEventsTransactByIdApiModel)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
