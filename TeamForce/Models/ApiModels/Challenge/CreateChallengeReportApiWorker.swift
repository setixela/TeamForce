//
//  CreateChallengeReportApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 07.10.2022.
//

import Foundation
import ReactiveWorks
import UIKit

struct ChallengeReportBody: Encodable {
   let challengeId: Int
   let text: String?
   let photo: UIImage?
   
   enum CodingKeys: String, CodingKey {
      case challengeId = "challenge"
      case text
      //case photo
   }
   init(challengeId: Int,
        text: String? = nil,
        photo: UIImage? = nil) {
      self.challengeId = challengeId
      self.text = text
      self.photo = photo
   }
}

struct CreateChallengeReportRequest {
   let token: String
   let body: ChallengeReportBody
}

final class CreateChallengeReportApiWorker: BaseApiWorker<CreateChallengeReportRequest, Void> {
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

      let endpoint = TeamForceEndpoints.CreateChallengeReport(
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
