//
//  GetFeedsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.08.2022.
//

import Foundation
import ReactiveWorks

struct Feed: Codable {
   let id: Int
   let time: String
   let eventType: EventType
   let transaction: Transaction
   //   let scope:

   struct EventType: Codable {
      let id: Int
      let name: String
      let objectType: String
      let isPersonal: Bool
      let hasScope: Bool

      enum CodingKeys: String, CodingKey {
         case id
         case name
         case objectType = "object_type"
         case isPersonal = "is_personal"
         case hasScope = "has_scope"
      }
   }
   
   struct Reaction: Codable {
      let id: Int
      let code: String?
      let counter: Int?
   }

   struct Transaction: Codable {
      let id: Int
      let senderId: Int?
      let sender: String
      let recipientId: Int?
      let recipient: String
      let status: String
      let isAnonymous: Bool
      let reason: String?
      let amount: Float
      let recipientPhoto: String?
      let recipientFirstName: String?
      let recipientSurname: String?
      let tags: [FeedTag]?
      let commentsAmount: Int?
      let lastLikeCommentTime: String?
      let userLiked: Bool?
      let userDisliked: Bool?
      let reactions: [Reaction]?

      enum CodingKeys: String, CodingKey {
         case id
         case senderId = "sender_id"
         case sender
         case recipientId = "recipient_id"
         case recipient
         case status
         case isAnonymous = "is_anonymous"
         case reason
         case amount
         case recipientPhoto = "recipient_photo"
         case recipientFirstName = "recipient_first_name"
         case recipientSurname = "recipient_surname"
         case tags
         case commentsAmount = "comments_amount"
         case lastLikeCommentTime = "last_like_comment_tim"
         case userLiked = "user_liked"
         case userDisliked = "user_disliked"
         case reactions
      }

      var photoUrl: String? {
         guard let photo = recipientPhoto else { return nil }

         return TeamForceEndpoints.urlBase + photo
      }
   }

   enum CodingKeys: String, CodingKey {
      case id
      case time
      case eventType = "event_type"
      case transaction
   }
}

final class GetFeedsApiWorker: BaseApiWorker<String, [Feed]> {
   override func doAsync(work: Wrk) {
      apiEngine?
         .process(endpoint: TeamForceEndpoints.Feed(headers: [
            "Authorization": work.input.string,
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let feeds: [Feed] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: feeds)
         }
         .catch { _ in
            work.fail()
         }
   }
}

struct FeedTag: Codable {
   let id: Int
   let name: String

   enum CodingKeys: String, CodingKey {
      case id = "tag_id"
      case name
   }
}
