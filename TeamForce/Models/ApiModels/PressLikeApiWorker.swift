//
//  PressLikeApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.09.2022.
//

import Foundation
import ReactiveWorks


struct PressLikeRequest: Indexable {
   let token: String
   let body: Body

   let index: Int

   struct Body: Codable {
      let likeKind: Int
      let transactionId: Int?
      let challengeId: Int?
      let challengeReportId: Int?
      
      init(likeKind: Int,
           transactionId: Int? = nil,
           challengeId: Int? = nil,
           challengeReportId: Int? = nil) {
         self.likeKind = likeKind
         self.transactionId = transactionId
         self.challengeId = challengeId
         self.challengeReportId = challengeReportId
      }
      
      enum CodingKeys: String, CodingKey {
         case likeKind = "like_kind"
         case transactionId = "transaction"
         case challengeId = "challenge_id"
         case challengeReportId = "challenge_report_id"
      }
      
   }
}

final class PressLikeApiWorker: BaseApiWorker<PressLikeRequest, Void> {
   override func doAsync(work: Work<PressLikeRequest, Void>) {
      let cookieName = "csrftoken"

      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }

      let jsonData = try? JSONEncoder().encode(request.body)
      
      apiEngine?
         .process(endpoint:
            TeamForceEndpoints.PressLike(
               headers: [
                  "Authorization": request.token,
                  "X-CSRFToken": cookie.value,
                  "Content-Type": "application/json"
               ], jsonData: jsonData))
         .done { result in
//            let str = String(decoding: result.data!, as: UTF8.self)
//            print(str)
//            print("response status \(String(describing: result.response))")
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
