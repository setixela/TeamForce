//
//  LogoutUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct LogoutUseCase: UseCaseProtocol {
   let loadToken: LoadTokenUseCase.WRK
   let logoutApiModel: LogoutApiWorker

   var work: Work<Void, Void> {
      Work<Void, Void> { work in
         loadToken
            .doAsync()
            .onFail {
               work.fail(())
            }
            .doMap {
               TokenRequest(token: $0)
            }
            .doNext(worker: logoutApiModel)
            .onSuccess {
               work.success(result: ())
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
