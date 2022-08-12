//
//  GetUsersListUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.08.2022.
//

import Foundation
import ReactiveWorks

struct GetUsersListUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getUsersListApiWorker: GetUsersListApiWorker
   
   var work: Work<Void, [FoundUser]> {
      Work<Void, [FoundUser]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }
            .doNext(worker: getUsersListApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
