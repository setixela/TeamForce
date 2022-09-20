//
//  PressLikeUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.09.2022.
//

import ReactiveWorks

struct PressLikeUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let pressLikeApiWorker: PressLikeApiWorker

   var work: Work<PressLikeRequest, Void> {
      Work<PressLikeRequest, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = PressLikeRequest(token: $0,
                                              likeKind: input.likeKind,
                                              transactionId: input.transactionId)
               return request
            }
            .doNext(worker: pressLikeApiWorker)
            .onSuccess {
               work.success(result: ())
            }
            .onFail {
               work.fail()
            }
      }
      
      
   }
}
