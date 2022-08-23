//
//  GetTransactionsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 04.08.2022.
//

import Foundation
import ReactiveWorks

struct Sender: Codable {
   let senderId: Int?
   let senderTgName: String?
   let senderFirstName: String?
   let senderSurname: String?
   let senderPhoto: String?

   enum CodingKeys: String, CodingKey {
      case senderId = "sender_id"
      case senderTgName = "sender_tg_name"
      case senderFirstName = "sender_first_name"
      case senderSurname = "sender_surname"
      case senderPhoto = "sender_photo"
   }
}

struct Recipient: Codable {
   let recipientId: Int?
   let recipientTgName: String?
   let recipientFirstName: String?
   let recipientSurname: String?
   let recipientPhoto: String?

   enum CodingKeys: String, CodingKey {
      case recipientId = "recipient_id"
      case recipientTgName = "recipient_tg_name"
      case recipientFirstName = "recipient_first_name"
      case recipientSurname = "recipient_surname"
      case recipientPhoto = "recipient_photo"
   }
}

struct TransactionStatus: Codable {
   let id: String?
   let name: String?

   enum CodingKeys: String, CodingKey {
      case id
      case name
   }
}

struct TransactionClass: Codable {
   let id: String?
   let name: String?

   enum CodingKeys: String, CodingKey {
      case id
      case name
   }
}

struct Transaction: Codable {
   let id: Int?
   let sender: Sender?
   let senderId: Int?
   let recipient: Recipient?
   let recipientId: Int?
   let transactionStatus: TransactionStatus?
   let transactionClass: TransactionClass?
   let expireToCancel: String?
   let amount: String?
   let createdAt: String?
   let updatedAt: String?
   let reason: String?
//   //
   let graceTimeout: Int?
   let isAnonymous: Bool?
   let isPublic: Bool?
   let photo: String?
   let organization: Int?
   let period: Int?
   let scope: Int?
//
//
//
   enum CodingKeys: String, CodingKey {
      case id
      case sender
      case senderId = "sender_id"
      case recipient
      case recipientId = "recipient_id"
      case transactionStatus = "transaction_status"
      case transactionClass = "transaction_class"
      case expireToCancel = "expire_to_cancel"
      case amount
      case createdAt = "created_at"
      case updatedAt = "updated_at"
      case reason
//
      case graceTimeout = "grace_timeout"
      case isAnonymous = "is_anonymous"
      case isPublic = "is_public"
      case photo
      case organization
      case period
      case scope
   }
}

struct GetTransactionsApiEvent: NetworkEventProtocol {
   var request: Event<TokenRequest>?
   var success: Event<[Transaction]>?
   var error: Event<ApiEngineError>?
}

final class GetTransactionsApiWorker: BaseApiWorker<String, [Transaction]> {
   override func doAsync(work: Wrk) {
      apiEngine?
         .process(endpoint: TeamForceEndpoints.GetTransactions(headers: [
            "Authorization": work.input ?? "",
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let transactions: [Transaction] = decoder.parse(data)
            else {
               work.fail(())
               return
            }
            work.success(result: transactions)
         }
         .catch { _ in
            work.fail(())
         }
   }
}
