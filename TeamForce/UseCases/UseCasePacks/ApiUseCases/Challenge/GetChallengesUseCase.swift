//
//  GetChallengesUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import Foundation
import ReactiveWorks

struct GetChallengesUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getChallengesApiWorker: GetChallengesApiWorker

   var work: Work<Void, [Challenge]> {
      Work<Void, [Challenge]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doNext(worker: getChallengesApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
