//
//  LogoutUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct LogoutUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let logoutApiModel: LogoutApiWorker

   func work() -> Work<Void, Void> {
      Work<Void, Void> { work in
         safeStringStorage
            .doAsync("token") // TODO: - Token key input
            .onFail {
               work.fail(()) // TODO: - Error
            }
            .doMap {
               TokenRequest(token: $0)
            }
            .doNext(worker: logoutApiModel)
            .onSuccess {
               work.success(result: ())
            }
            .onFail {
               work.fail(()) // TODO: - Error
            }
      }
   }
}
