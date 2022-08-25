//
//  VerifyCodeUseCase.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.08.2022.
//

import ReactiveWorks

struct VerifyCodeUseCase: UseCaseProtocol {
   let verifyCodeApiWorker: VerifyApiModel

   var work: Work<VerifyRequest, VerifyResultBody> {
      verifyCodeApiWorker.work
   }
}
