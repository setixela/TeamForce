//
//  SetFcmTokenApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 09.11.2022.
//

import Foundation
import ReactiveWorks

struct FcmToken: Codable {
   let token: String
   let device: String
}

final class SetFcmTokenApiWorker: BaseApiWorker<FcmToken, Void> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let request = work.input
      else {
         work.fail()
         return
      }

      apiEngine?
         .process(endpoint: TeamForceEndpoints.CreateComment(headers: [
            "Authorization": request.token,
         ], body: request.dictionary ?? [:]))
         .done { result in
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
