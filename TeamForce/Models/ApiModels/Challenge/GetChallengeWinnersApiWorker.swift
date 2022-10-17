//
//  GetChallengeWinnersApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 07.10.2022.
//

import Foundation
import ReactiveWorks
struct ChallengeWinner: Codable {
   let nickname: String?
   let totalReceived: Int?
   let participantId: Int?
   let participantPhoto: String?
   let participantName: String?
   let participantSurname: String?
   let awardedAt: String?
   
   enum CodingKeys: String, CodingKey {
      case nickname
      case totalReceived = "total_received"
      case participantId = "participant_id"
      case participantPhoto = "participant_photo"
      case participantName = "participant_name"
      case participantSurname = "participant_surname"
      case awardedAt = "awarded_at"
   }
}

final class GetChallengeWinnersApiWorker: BaseApiWorker<RequestWithId, [ChallengeWinner]> {
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
         .process(endpoint: TeamForceEndpoints.ChallengeWinners(
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
               let winners: [ChallengeWinner] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: winners)
         }
         .catch { _ in
            work.fail()
         }
   }
}
