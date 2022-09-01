//
//  LoadBothTokensUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.08.2022.
//

import ReactiveWorks

struct LoadBothTokensUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageUseCase.WRK

   var work: VoidWork<(token: String, csrf: String)> { .init { work in
      safeStringStorage
         .doAsync("token")
         .onFail {
            work.fail(())
         }
         .onSuccess {
            log($0)
         }
         .doSaveResult()
         .doInput("csrftoken")
         .doAsync()
         .onSuccessMixSaved { token, csrf in
            work.success(result: (token, csrf))
         }.onFail {
            work.fail(())
         }
   } }
}
