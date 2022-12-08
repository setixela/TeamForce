//
//  CloseChallengeUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 08.12.2022.
//

import ReactiveWorks

struct CloseChallengeUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let closeChallengeApiWorker: CloseChallengeApiWorker

   var work: Work<Int, Void> {
      Work<Int, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               log("No token")
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: closeChallengeApiWorker)
            .onSuccess {
               work.success()
            }
            .onFail {
               work.fail()
            }
      }
   }
}
