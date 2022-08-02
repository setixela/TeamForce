//
//  LoginUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation

struct LoginUseCase: UseCaseProtocol {
   let authApiWorker: AuthApiWorker

   func work() -> Work<String, AuthResult> {
      authApiWorker.work
   }
}
