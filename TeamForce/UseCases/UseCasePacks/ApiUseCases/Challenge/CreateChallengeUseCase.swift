//
//  CreateChallengeUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import ReactiveWorks

struct CreateChallengeUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let createChallengeApiWorker: CreateChallengeApiWorker

   var work: Work<ChallengeRequestBody, Void> {
      Work<ChallengeRequestBody, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
               return CreateChallengeRequest(token: $0, body: input)
            }
            .doNext(worker: createChallengeApiWorker)
            .onSuccess {
               work.success()
            }
            .onFail {
               work.fail()
            }
      }
   }
}
