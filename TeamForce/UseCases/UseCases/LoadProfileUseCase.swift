//
//  LoadProfileUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct LoadProfileUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let userProfileApiModel: ProfileApiWorker

   func work() -> Work<Void, UserData> {
      Work<Void, UserData> { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }.doMap {
               TokenRequest(token: $0)
            }
            .doNext(worker: userProfileApiModel)
            .onSuccess { userData in
               work.success(result: userData)
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
