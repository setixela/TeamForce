//
//  CreateFewContactsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 07.09.2022.
//

import ReactiveWorks

struct CreateFewContactsUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let createFewContactsApiWorker: CreateFewContactsApiWorker

   var work: Work<CreateFewContactsRequest, Void> {
      Work<CreateFewContactsRequest, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               let request = CreateFewContactsRequest(token: $0,
                                                      info: input.info)
               return request
            }
            .doNext(worker: createFewContactsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
