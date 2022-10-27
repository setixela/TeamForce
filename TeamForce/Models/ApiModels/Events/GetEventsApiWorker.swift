//
//  GetEventsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 25.10.2022.
//

protocol Indexable {
   var index: Int { get }
}

struct NewFeed: Codable {
   let id: Int
   let time: String?
   let eventTypeId: Int
   let eventObjectId: Int?
   let eventRecordId: Int?
   let objectSelector: String?
   var likesAmount: Int
   var commentsAmount: Int
   var transaction: EventTransaction?
   var challenge: Challenge?
   var winner: Winner?

   enum CodingKeys: String, CodingKey {
      case id, time
      case eventTypeId = "event_type_id"
      case eventObjectId = "event_object_id"
      case eventRecordId = "event_record_id"
      case objectSelector = "object_selector"
      case likesAmount = "likes_amount"
      case commentsAmount = "comments_amount"
      case transaction
      case challenge
      case winner
   }

//   struct Transaction: Codable {
//      let id: Int
//      let userLiked: Bool
//      let amount: Int
//      let updatedAt: String
//      let senderId: Int?
//      let recipientId: Int?
//      let isAnonymous: Bool
//      let senderTgName: String?
//      let recipientTgName: String?
//      let recipientPhoto: String?
//      let tags: [FeedTag]?
//
//      enum CodingKeys: String, CodingKey {
//         case id
//         case userLiked = "user_liked"
//         case amount
//         case updatedAt = "updated_at"
//         case senderId = "sender_id"
//         case recipientId = "recipient_id"
//         case isAnonymous = "is_anonymous"
//         case senderTgName = "sender_tg_name"
//         case recipientTgName = "recipient_tg_name"
//         case recipientPhoto = "recipient_photo"
//         case tags
//      }
//
//      var photoUrl: String? {
//         guard let photo = recipientPhoto else { return nil }
//
//         return TeamForceEndpoints.urlBase + photo
//      }
//   }

   struct Challenge: Codable {
      let id: Int
      var userLiked: Bool
      let photo: String?
      let createdAt: String?
      let name: String
      let creatorId: Int
      let creatorFirstName: String?
      let creatorSurname: String?
      let creatorTgName: String?

      enum CodingKeys: String, CodingKey {
         case id, photo, name
         case userLiked = "user_liked"
         case createdAt = "created_at"
         case creatorId = "creator_id"
         case creatorFirstName = "creator_first_name"
         case creatorSurname = "creator_surname"
         case creatorTgName = "creator_tg_name"
      }
   }

   struct Winner: Codable {
      let id: Int
      var userLiked: Bool
      let updatedAt: String?
      let challengeName: String
      let winnerId: Int
      let winnerFirstName: String?
      let winnerSurname: String?
      let winnerTgName: String?
      let winnerPhoto: String?

      enum CodingKeys: String, CodingKey {
         case id
         case userLiked = "user_liked"
         case updatedAt = "updated_at"
         case challengeName = "challenge_name"
         case winnerId = "winner_id"
         case winnerFirstName = "winner_first_name"
         case winnerSurname = "winner_surname"
         case winnerTgName = "winner_tg_name"
         case winnerPhoto = "winner_photo"
      }
   }
}

final class GetEventsApiWorker: BaseApiWorker<(String, Pagination), [NewFeed]> {
   override func doAsync(work: Wrk) {
      guard let request = work.input
      else {
         work.fail()
         return
      }

      let endpoint = TeamForceEndpoints.Events(
         offset: request.1.offset,
         limit: request.1.limit,
         headers: ["Authorization": request.0]
      )

      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let feeds: [NewFeed] = decoder.parse(data)
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
