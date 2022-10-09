//
//  CheckChallengeReportApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 09.10.2022.
//

import Foundation
import ReactiveWorks

struct CheckReportRequestBody: Codable {
   let id: Int
   let state: State
   
   enum State: String, Codable {
      case W = "W"
      case D = "D"
   }
   
   enum CodingKeys: String, CodingKey {
      case id
      case state
   }
}

struct CheckReportRequest {
   let token: String
   let body: CheckReportRequestBody
}

final class CheckChallengeReportApiWorker: BaseApiWorker<CheckReportRequest, Void> {
   override func doAsync(work: Work<CheckReportRequest, Void>) {
      let cookieName = "csrftoken"
      
      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail()
         return
      }
      
      let jsonData = try? JSONEncoder().encode(request.body)
      let endpoint = TeamForceEndpoints.CheckChallengeReport(
         id: String(request.body.id),
         headers: ["Authorization": request.token,
                   "X-CSRFToken": cookie.value,
                   "Content-Type": "application/json"],
         jsonData: jsonData
      )
      
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
