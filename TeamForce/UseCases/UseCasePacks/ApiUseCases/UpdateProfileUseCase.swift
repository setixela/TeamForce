//
//  UpdateProfileUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks
import UIKit

struct UpdateProfileUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let updateProfileApiWorker: UpdateProfileApiWorker
   
   var work: Work<UpdateProfileRequest, Void> {
      Work<UpdateProfileRequest, Void> { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard
                  let id = work.input?.id,
                  let info = work.input?.info
               else { return nil }
               return UpdateProfileRequest(token: $0,
                                           id: id,
                                           info: info)
            }
            .doNext(worker: updateProfileApiWorker)
            .onSuccess {
               work.success()
            }
            .onFail {
               work.fail()
            }
      }
   }
}
