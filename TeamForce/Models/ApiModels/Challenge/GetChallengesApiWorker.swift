//
//  GetChallengesApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import Foundation
import ReactiveWorks

struct Challenge: Codable {
   let id: Int
   let name: String?
   let photo: String?
   let updatedAt: String?
   let states: [String]?
   let description: String?
   let startBalance: Int?
   let creatorId: Int
   let parameters: [Parameter]?
   let endAt: String?
   let approvedReportsAmount: Int
   let status: String?
   let isNewReports: Bool
   let winnersCount: Int?
   let creatorOrganizationId: Int?
   let prizeSize: Int
   let awardees: Int
   let fund: Int
   let creatorName: String?
   let creatorSurname: String?
   let creatorPhoto: String?
   let creatorTgName: String?
   let active: Bool?
   let completed: Bool?
   let remainingTopPlaces: Int?

   struct Parameter: Codable {
      let id: Int
      let value: Int?
      let isCalc: Bool?

      enum CodingKeys: String, CodingKey {
         case id
         case value
         case isCalc = "is_calc"
      }
   }

   enum CodingKeys: String, CodingKey {
      case id, name, photo
      case updatedAt = "updated_at"
      case states
      case description
      case startBalance = "start_balance"
      case creatorId = "creator_id"
      case parameters
      case endAt = "end_at"
      case approvedReportsAmount = "approved_reports_amount"
      case status
      case isNewReports = "is_new_reports"
      case winnersCount = "winners_count"
      case creatorOrganizationId = "creator_organization_id"
      case prizeSize = "prize_size"
      case awardees, fund
      case creatorName = "creator_name"
      case creatorSurname = "creator_surname"
      case creatorPhoto = "creator_photo"
      case creatorTgName = "creator_tg_name"
      case active, completed
      case remainingTopPlaces = "remaining_top_places"
   }
}

final class GetChallengesApiWorker: BaseApiWorker<String, [Challenge]> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let token = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.GetChallenges(headers: [
            "Authorization": token,
            "X-CSRFToken": cookie.value
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let challenges: [Challenge] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: challenges)
         }
         .catch { _ in
            work.fail()
         }
   }
}

//var getChallenges: Work<Void, [Challenge]> { .init { [weak self] work in
//   //guard let input = work.input else { return }
//   self?.apiUseCase.getChanllenges
//      .doAsync()
//      .onSuccess {
//         work.success(result: $0)
//      }
//      .onFail {
//         work.fail()
//      }
//}.retainBy(retainer) }
