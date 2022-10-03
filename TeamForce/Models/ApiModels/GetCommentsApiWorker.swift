//
//  GetCommentsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import Foundation
import ReactiveWorks

struct CommentsRequest {
   let token: String
   let body: CommentsRequestBody
}

struct CommentsRequestBody: Codable {
   let transactionId: Int
   let offset: Int?
   let limit: Int?
   let includeName: Bool?
   let isReverseOrder: Bool?

   enum CodingKeys: String, CodingKey {
      case transactionId = "transaction_id"
      case offset
      case limit
      case includeName = "include_name"
      case isReverseOrder = "is_reverse_order"
   }

   init(transactionId: Int,
        offset: Int? = nil,
        limit: Int? = nil,
        includeName: Bool? = nil,
        isReverseOrder: Bool? = nil)
   {
      self.transactionId = transactionId
      self.offset = offset
      self.limit = limit
      self.includeName = includeName
      self.isReverseOrder = isReverseOrder
   }
}

struct User: Codable {
   let id: Int
   let name: String?
   let surname: String?
   let avatar: String?
}

struct Comment: Codable {
   let id: Int
   let text: String?
   let picture: String?
   let created: String?
   let edited: String?
   let user: User?
}

struct CommentsResponse: Codable {
   let transactionId: Int
   let comments: [Comment]?

   enum CodingKeys: String, CodingKey {
      case transactionId = "transaction_id"
      case comments
   }
}

final class GetCommentsApiWorker: BaseApiWorker<CommentsRequest, [Comment]> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }
      let jsonData = try? JSONEncoder().encode(request.body)
      let endpoint = TeamForceEndpoints.GetComments(
         headers: ["Authorization": request.token,
                   "X-CSRFToken": cookie.value,
                   "Content-Type": "application/json"],
         jsonData: jsonData
      )
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let response: CommentsResponse = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: response.comments ?? [])
         }
         .catch { _ in
            work.fail()
         }
   }
}

extension Encodable {
   var dictionary: [String: Any]? {
      guard let data = try? JSONEncoder().encode(self) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
   }
}
