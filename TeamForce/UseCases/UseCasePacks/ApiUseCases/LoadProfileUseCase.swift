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
   let saveUserIdWork: SaveCurrentUserIdUseCase.WRK
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
            .onFail {
               work.fail()
            }
            .doSaveResult()
            .doMap {
               $0.userName
            }
            .doNext(saveUserNameWork)
            .onFail {
               assertionFailure("cannot save saveUserNameWork")
            }
            .doLoadResult()
            .doMap { (userData: UserData) in
               userData.profile.id.toString
            }
            .doNext(saveUserIdWork)
            .doLoadResult()
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               assertionFailure("cannot save saveUserNameWork")
            }
      }
   }
}
