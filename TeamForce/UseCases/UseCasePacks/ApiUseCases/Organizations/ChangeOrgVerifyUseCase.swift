//
//  ChangeOrgVerifyUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import ReactiveWorks

struct ChangeOrgVerifyCodeUseCase: UseCaseProtocol {
   let changeOrgVerifyApiWorker: ChangeOrgVerifyApiWorker

   var work: Work<VerifyRequest, VerifyResultBody> {
      changeOrgVerifyApiWorker.work
   }
}
