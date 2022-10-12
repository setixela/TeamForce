//
//  CreateChallengeApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import Foundation
import ReactiveWorks
import UIKit


struct ChallengeRequestBody: Encodable {
   let name: String
   let description: String?
   let endAt: String?
   let startBalance: Int
   let photo: UIImage?
   let parameterId: Int?
   let parameterValue: Int?

   enum CodingKeys: String, CodingKey {
      case name, description // , photo
      case endAt = "end_at"
      case startBalance = "start_balance"
      case parameterId = "parameter_id"
      case parameterValue = "parameter_value"
   }

   init(name: String,
        description: String? = nil,
        endAt: String? = nil,
        startBalance: Int,
        photo: UIImage? = nil,
        parameterId: Int? = nil,
        parameterValue: Int? = nil)
   {
      self.name = name
      self.description = description
      self.endAt = endAt
      self.startBalance = startBalance
      self.photo = photo
      self.parameterId = parameterId
      self.parameterValue = parameterValue
   }
}

struct CreateChallengeRequest {
   let token: String
   let body: ChallengeRequestBody
}

final class CreateChallengeApiWorker: BaseApiWorker<CreateChallengeRequest, Void> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }
      let body = request.body.dictionary ?? [:]

      let endpoint = TeamForceEndpoints.CreateChallenge(
         headers: [
            "Authorization": request.token,
            "X-CSRFToken": cookie.value
         ],
         body: body
      )
      if let photo = request.body.photo {
         apiEngine?
            .processWithImage(endpoint: endpoint,
                              image: photo)
            .done { _ in
               work.success()
            }
            .catch { error in
               print("error coin sending: \(error)")
               work.fail()
            }
      } else {
         apiEngine?
            .process(endpoint: endpoint)
            .done { _ in
               work.success()
            }
            .catch { _ in
               work.fail()
            }
      }
   }
}
