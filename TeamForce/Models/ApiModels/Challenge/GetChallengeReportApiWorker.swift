//
//  GetChallengeReportApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.10.2022.
//

import Foundation
import ReactiveWorks

struct ChallengeReport: Codable {
   struct Challenge: Codable {
      let id: Int
      let name: String?
   }
   let challenge: Challenge
   let user: User
   let text: String?
   let photo: String?
}

final class GetChallengeReportApiWorker: BaseApiWorker<RequestWithId, ChallengeReport> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.ChallengeReport(
            id: String(request.id),
            headers: [
               "Authorization": request.token,
               "X-CSRFToken": cookie.value
            ]
         ))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let report: ChallengeReport = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: report)
         }
         .catch { _ in
            work.fail()
         }
   }
}
