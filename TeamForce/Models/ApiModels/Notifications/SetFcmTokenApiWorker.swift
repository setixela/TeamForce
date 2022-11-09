//
//  SetFcmTokenApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 09.11.2022.
//

import Foundation
import ReactiveWorks

struct FcmRequest {
   let token: String
   let fcmToken: FcmToken
}
struct FcmToken: Codable {
   let token: String
   let device: String
}

final class SetFcmTokenApiWorker: BaseApiWorker<FcmRequest, Void> {
   override func doAsync(work: Wrk) {
      
      guard
         let request = work.input
      else {
         work.fail()
         return
      }

      apiEngine?
         .process(endpoint: TeamForceEndpoints.SetFcmToken(headers: [
            "Authorization": request.token,
         ], body: request.fcmToken.dictionary ?? [:]))
         .done { result in
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
