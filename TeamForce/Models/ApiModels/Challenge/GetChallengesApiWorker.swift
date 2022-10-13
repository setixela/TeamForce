//
//  GetChallengesApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import Foundation
import ReactiveWorks
enum ChallengeState: String, Codable {
   case O = "От имени организации"
   case U = "От имени пользователя"
   case P = "Является публичным"
   case C = "Является командным"
   case R = "Нужна регистрация"
   case G = "Нужна картинка"
   case M = "Запрет комментариев"
   case E = "Разрешить комментарии только для участников"
   case L = "Лайки запрещены"
   case T = "Разрешить лайки только для участников"
   case X = "Комментарии отчетов разрешены только автору отчета, организатору и судьям"
   case W = "Комментарии отчетов разрешены только участникам"
   case I = "Лайки отчетов разрешены только участникам"
   case N = "Участник может использовать никнейм"
   case H = "Участник может сделать отчёт приватным"
   case A = "Отчеты анонимизированы до подведения итогов, не видны ни имена пользователей, ни псевдонимы"
   case Q = "Участник может рассылать приглашения"
   case Y = "Подтверждение будет выполняться судейской коллегией (через выдачу ими баллов)"
}

enum ChallengeStatus: String, Codable {
   case owner = "Вы создатель челленджа"
   case canSendReport = "Можно отправить отчёт"
   case reportSent = "Отчёт отправлен"
   case reportAccepted = "Отчёт подтверждён"
   case reportDeclined = "Отчёт отклонён"
   case rewarded = "Получено вознаграждение"
}

struct Challenge: Codable {
   let id: Int
   let name: String?
   let photo: String?
   let updatedAt: String?
   let states: [ChallengeState]?
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
