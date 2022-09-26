//
//  UpdateCommentUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks

struct UpdateCommentUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let updateCommentApiWorker: UpdateCommentApiWorker

   var work: Work<UpdateCommentRequest, Void> {
      Work<UpdateCommentRequest, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = UpdateCommentRequest(token: $0,
                                                  id: input.id,
                                                  body: input.body)
               return request
            }
            .doNext(worker: updateCommentApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
