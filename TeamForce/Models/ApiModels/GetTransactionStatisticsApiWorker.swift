//
//  GetTransactionStatistics.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 21.09.2022.
//

import Foundation
import ReactiveWorks

struct LikeKind: Codable {
   let id: Int
   let code: String?
}

struct Like: Codable {
   let likeKind: LikeKind?
   let counter: Int?
   let lastChanged: String?
   let items: [Item]?

   struct Item: Codable {
      let timeOf: String
      let user: User

      enum CodingKeys: String, CodingKey {
         case timeOf = "time_of"
         case user
      }
   }

   enum CodingKeys: String, CodingKey {
      case likeKind = "like_kind"
      case counter
      case lastChanged = "last_changed"
      case items
   }
}

struct TransactStatistics: Codable {
   let transactionId: Int
   let comments: Int?
   let likes: [Like]?
   
   enum CodingKeys: String, CodingKey {
      case transactionId = "transaction_id"
      case comments
      case likes
   }
}

struct TransactStatRequest {
   let token: String?
   let transactionId: Int
}

final class GetTransactionStatisticsApiWorker: BaseApiWorker<TransactStatRequest, TransactStatistics> {
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
         .process(endpoint: TeamForceEndpoints.GetTransactionStatistics(headers: [
            "Authorization": request.token.string,
            "X-CSRFToken": cookie.value
         ], body: [
            "transaction_id": request.transactionId
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let stat: TransactStatistics = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: stat)
         }
         .catch { _ in
            work.fail()
         }
   }
}
