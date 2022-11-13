//
//  RemoveFcmTokenApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 09.11.2022.
//

import ReactiveWorks

struct RemoveFcmRequest {
   let token: String
   let removeFcmToken: RemoveFcmToken
}

struct RemoveFcmToken: Codable {
   let device: String
   let userId: Int

   enum CodingKeys: String, CodingKey {
      case device
      case userId = "user_id"
   }
}

final class RemoveFcmTokenApiWorker: BaseApiWorker<RemoveFcmRequest, Void> {
   override func doAsync(work: Wrk) {
      guard
         let request = work.input
      else {
         work.fail()
         return
      }

      apiEngine?
         .process(endpoint: TeamForceEndpoints.RemoveFcmToken(headers: [
            "Authorization": request.token,
         ], body: request.removeFcmToken.dictionary ?? [:]))
         .done { _ in
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
