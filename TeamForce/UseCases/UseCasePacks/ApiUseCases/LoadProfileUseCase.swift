//
//  LoadProfileUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct LoadProfileUseCase: UseCaseProtocol {
   let loadToken: LoadTokenUseCase.WRK
   let saveUserNameWork: SaveCurrentUserUseCase.WRK
   let userProfileApiModel: ProfileApiWorker

   var work: Work<Void, UserData> {
      Work<Void, UserData> { work in
         loadToken
            .doAsync()
            .onFail {
               work.fail()
            }.doMap {
               TokenRequest(token: $0)
            }
            .doNext(worker: userProfileApiModel)
            .onSuccess { userData in
               work.success(result: userData)
            }
            .onFail {
               work.fail()
            }
            .doMap {
               $0.userName
            }
            .doNext(saveUserNameWork)
            .onFail {
               assertionFailure("cannot save saveUserNameWork")
            }
      }
   }
}
