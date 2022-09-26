//
//  CreateCommentUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks

struct CreateCommentUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let createCommentsApiWorker: CreateCommentApiWorker

   var work: Work<CreateCommentRequest, Void> {
      Work<CreateCommentRequest, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = CreateCommentRequest(token: $0,
                                                 body: input.body)
               return request
            }
            .doNext(worker: createCommentsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
