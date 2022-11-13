//
//  GetCurrentUserUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.11.2022.
//

import ReactiveWorks

fileprivate let currentUserKey = "currentUser"

struct GetCurrentUserUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageProtocol

   var work: VoidWork<String> {
      .init {
         guard let curUser = safeStringStorage.load(forKey: currentUserKey) else {
            $0.fail()
            return
         }

         $0.success(curUser)
      }
   }
}

struct SaveCurrentUserUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageProtocol

   var work: Work<String, String> {
      .init {
         safeStringStorage.save($0.unsafeInput, forKey: currentUserKey)

         $0.success($0.unsafeInput)
      }
   }
}
