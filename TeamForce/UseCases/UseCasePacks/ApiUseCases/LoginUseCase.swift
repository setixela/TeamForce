//
//  LoginUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation
import ReactiveWorks

struct LoginUseCase: UseCaseProtocol {
   let authApiWorker: AuthApiWorker

   var work: Work<String, Auth2Result> {
      authApiWorker.work
   }
}
