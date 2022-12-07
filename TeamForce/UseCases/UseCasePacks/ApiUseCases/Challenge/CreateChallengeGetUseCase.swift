//
//  CreateChallengeGetUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.12.2022.
//

import ReactiveWorks

struct CreateChallengeGetUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let createChallengeGetApiWorker: CreateChallengeGetApiWorker

   var work: Work<Void, CreateChallengeSettings> {
      Work<Void, CreateChallengeSettings>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doNext(worker: createChallengeGetApiWorker)
            .onSuccess {
               work.success($0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
