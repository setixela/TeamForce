//
//  ChangeOrganizationUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import Foundation
import ReactiveWorks

struct ChangeOrganizationUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let changeOrganizationApiWorker: ChangeOrganizationApiWorker
   
   var work: Work<Int, AuthResult> {
      Work<Int, AuthResult>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard let id = work.input else { return nil }
               return RequestWithId(token: $0, id: id)
            }
            .doNext(worker: changeOrganizationApiWorker)
            .onSuccess {
               work.success($0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
