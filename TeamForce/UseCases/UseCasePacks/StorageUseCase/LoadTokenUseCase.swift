//
//  LoadTokenUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.08.2022.
//

import ReactiveWorks

struct LoadTokenUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageUseCase.WRK

   var work: WorkVoid<String> {
      .init { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .onSuccess {
               work.success(result: $0)
            }
      }
   }
}
