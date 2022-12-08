//
//  GetChallengesApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import ReactiveWorks
import UIKit

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

final class Challenge: Codable {
   internal init(
      id: Int,
      userLiked: Bool? = nil,
      likesAmount: Int? = nil,
      name: String? = nil,
      photo: String? = nil,
      updatedAt: String? = nil,
      states: [ChallengeState]? = nil,
      description: String? = nil,
      startBalance: Int? = nil,
      creatorId: Int,
      parameters: [Challenge.Parameter]? = nil,
      endAt: String? = nil,
      approvedReportsAmount: Int,
      status: String? = nil,
      isNewReports: Bool,
      winnersCount: Int? = nil,
      creatorOrganizationId: Int? = nil,
      prizeSize: Int,
      awardees: Int,
      fund: Int,
      creatorName: String? = nil,
      creatorSurname: String? = nil,
      creatorPhoto: String? = nil,
      creatorTgName: String? = nil,
      active: Bool? = nil,
      completed: Bool? = nil,
      remainingTopPlaces: Int? = nil,
      photoCache: UIImage? = nil,
      algorithmName: String? = nil,
      algorithmType: Int? = nil,
      showContenders: Bool? = nil
   ) {
      self.id = id
      self.userLiked = userLiked
      self.likesAmount = likesAmount
      self.name = name
      self.photo = photo
      self.updatedAt = updatedAt
      self.states = states
      self.description = description
      self.startBalance = startBalance
      self.creatorId = creatorId
      self.parameters = parameters
      self.endAt = endAt
      self.approvedReportsAmount = approvedReportsAmount
      self.status = status
      self.isNewReports = isNewReports
      self.winnersCount = winnersCount
      self.creatorOrganizationId = creatorOrganizationId
      self.prizeSize = prizeSize
      self.awardees = awardees
      self.fund = fund
      self.creatorName = creatorName
      self.creatorSurname = creatorSurname
      self.creatorPhoto = creatorPhoto
      self.creatorTgName = creatorTgName
      self.active = active
      self.completed = completed
      self.remainingTopPlaces = remainingTopPlaces
      self.photoCache = photoCache
      self.algorithmName = algorithmName
      self.algorithmType = algorithmType
      self.showContenders = showContenders
   }

   let id: Int
   let userLiked: Bool?
   let likesAmount: Int?
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
   let algorithmName: String?
   let algorithmType: Int?
   let showContenders: Bool?

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
      case likesAmount = "likes_amount"
      case userLiked = "user_liked"
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
      case algorithmName = "algorithm_name"
      case algorithmType = "algorithm_type"
      case showContenders = "show_contenders"
   }

   // not codable extensions
   var photoCache: UIImage?
}

struct ChallengesRequest {
   let token: String
   let activeOnly: Bool?
   let pagination: Pagination?
}

final class GetChallengesApiWorker: BaseApiWorker<ChallengesRequest, [Challenge]> {
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
         .process(endpoint: TeamForceEndpoints.GetChallenges(
            activeOnly: request.activeOnly ?? false,
            headers: [
               "Authorization": request.token,
               "X-CSRFToken": cookie.value
            ]
         ))
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
