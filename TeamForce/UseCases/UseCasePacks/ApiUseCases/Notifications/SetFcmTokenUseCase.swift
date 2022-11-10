//
//  SetFcmTokenUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 09.11.2022.
//

import ReactiveWorks

struct SetFcmTokenUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let setFcmTokenApiWorker: SetFcmTokenApiWorker

   var work: Work<FcmToken, Void> {
      Work<FcmToken, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               print("hello")
               guard let input = work.input else { return nil }
               let request = FcmRequest(token: $0, fcmToken: input)
               return request
            }
            .doNext(worker: setFcmTokenApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
