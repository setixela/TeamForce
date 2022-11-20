//
//  LoadCsrfTokenUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.08.2022.
//

import ReactiveWorks

struct LoadCsrfTokenUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageUseCase.WRK

   var work: WorkVoid<String> {
      .init { work in
         safeStringStorage
            .doAsync("csrftoken")
            .onFail {
               work.fail()
            }
            .onSuccess {
               work.success(result: $0)
            }
      }
   }
}
