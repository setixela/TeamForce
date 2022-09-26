//
//  GetCommentsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks

struct GetCommentsUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getCommentsApiWorker: GetCommentsApiWorker

   var work: Work<CommentsRequest, [Comment]> {
      Work<CommentsRequest, [Comment]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = CommentsRequest(token: $0,
                                                 body: input.body)
               return request
            }
            .doNext(worker: getCommentsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
