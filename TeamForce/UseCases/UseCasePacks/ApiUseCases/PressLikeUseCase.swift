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

   var work: Work<PressLikeRequest, PressLikeResult> {
      Work<PressLikeRequest, PressLikeResult>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = PressLikeRequest(token: $0, body: input.body, index: input.index)
               return request
            }
            .doNext(worker: pressLikeApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
