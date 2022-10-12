//
//  GetSendCoinSettingsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks

struct GetSendCoinSettingsUseCase: UseCaseProtocol {
   let getSendCoinSettingsApiWorker: GetSendCoinSettingsApiWorker

   var work: Work<String, SendCoinSettings> {
      Work<String, SendCoinSettings>() { work in
         getSendCoinSettingsApiWorker
            .doAsync(work.unsafeInput)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
