//
//  GetChallengeResultApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 13.10.2022.
//

import Foundation
import ReactiveWorks

struct ChallengeResult: Codable {
   let updatedAt: String
   let text: String?
   let photo: String?
   let status: String
   let received: Int?

   enum CodingKeys: String, CodingKey {
      case text, photo, status, received
      case updatedAt = "updated_at"
   }
}

final class GetChallengeResultApiWorker: BaseApiWorker<RequestWithId, [ChallengeResult]> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail()
         return
      }
      let endpoint = TeamForceEndpoints.ChallengeResult(
         id: String(request.id),
         headers: [
            "Authorization": request.token,
            "X-CSRFToken": cookie.value
         ]
      )
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let challengeResults: [ChallengeResult] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: challengeResults)
         }
         .catch { _ in
            work.fail()
         }
   }
}
