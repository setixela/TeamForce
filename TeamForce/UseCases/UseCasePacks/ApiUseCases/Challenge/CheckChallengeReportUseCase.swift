//
//  CheckChallengeReportUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 09.10.2022.
//

import ReactiveWorks

struct CheckChallengeReportUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let checkChallengeReportApiWorker: CheckChallengeReportApiWorker

   var work: Work<CheckReportRequestBody, Void> {
      Work<CheckReportRequestBody, Void>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let input = work.input else { return nil }
//               return CheckReportRequest(token: $0, body: input)
//               print("input \(input)")
//               let request = CheckReportRequestBody(id: 42, state: CheckReportRequestBody.State.D)
               return CheckReportRequest(token: $0, body: input)
            }
            .doNext(worker: checkChallengeReportApiWorker)
            .onSuccess {
               work.success()
            }
            .onFail {
               work.fail()
            }
      }
   }
}
