//
//  ChangeOrganizationVerifyApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import Foundation
import ReactiveWorks

final class ChangeOrgVerifyApiWorker: BaseApiWorker<VerifyRequest, VerifyResultBody> {
   override func doAsync(work: Work<VerifyRequest, VerifyResultBody>) {
      let cookieName = "csrftoken"

      guard
         let verifyRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }

      apiEngine?
         .process(endpoint: TeamForceEndpoints.ChangeOrganizationVerifyEndpoint(
            body: ["type": "authcode",
                   "code": verifyRequest.smsCode],
            headers: ["X-CSRFToken": cookie.value,
                      "tg_id": verifyRequest.xId,
                      "X-Code": verifyRequest.xCode,
                      "organization_id": verifyRequest.organizationId ?? ""]))
         .done { result in
            let decoder = DataToDecodableParser()

            guard
               let data = result.data,
               let resultBody: VerifyResultBody = decoder.parse(data)
            else {
               work.fail()
               return
            }

            work.success(result: resultBody)
         }
         .catch { error in
            print(error)
            work.fail()
         }
   }
}
