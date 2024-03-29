//
//  VerifyApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import Foundation
import ReactiveWorks

struct VerifyRequest {
   let xId: String
   let xCode: String
   let smsCode: String
   let organizationId: String?
   init(xId: String,
        xCode: String,
        smsCode: String,
        organizationId: String? = nil)
   {
      self.xId = xId
      self.xCode = xCode
      self.smsCode = smsCode
      self.organizationId = organizationId
   }
}

struct VerifyResult {
   let type: String //  "authresult",
   let isSuccess: Bool //  false
}

struct VerifyResultBody: Codable {
   let type: String
   let isSuccess: Bool
   let token: String
   let sessionId: String

   enum CodingKeys: String, CodingKey {
      case sessionId = "sessionid"
      case isSuccess = "is_success"
      case type
      case token
   }
}

final class VerifyApiModel: BaseApiWorker<VerifyRequest, VerifyResultBody> {
   override func doAsync(work: Work<VerifyRequest, VerifyResultBody>) {
      guard let verifyRequest = work.input else { return }
      print(verifyRequest)
      var body = ["type": "authcode",
                  "code": verifyRequest.smsCode]
      if let orgId = verifyRequest.organizationId {
         body["organization_id"] = orgId
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.VerifyEndpoint(
            body: body,
            headers: ["X-ID": verifyRequest.xId,
                      "X-Code": verifyRequest.xCode]))
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
         .catch { _ in
            work.fail()
         }
   }
}
