//
//  GetUserOrganizationsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import ReactiveWorks

struct GetUserOrganizationsUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getUserOrganizationsApiWorker: GetUserOrganizationsApiWorker

   var work: Work<Void, [Organization]> {
      Work<Void, [Organization]>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               $0
            }
            .doNext(worker: getUserOrganizationsApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
