//
//  AuthApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import Foundation
import PromiseKit
import ReactiveWorks

protocol NetworkEventProtocol: InitProtocol {
   associatedtype Request
   associatedtype Result
   associatedtype Error

   var request: Event<Request>? { get set }
   var success: Event<Result>? { get set }
   var error: Event<Error>? { get set }
}

struct TokenRequest {
   let token: String
}

struct UserData: Codable {
   let userName: String
   let profile: Profile

   enum CodingKeys: String, CodingKey {
      case userName = "username"
      case profile
   }

   struct Profile: Codable {
      let id: Int
      let organization: String
      let department: String
      let tgId: String
      let tgName: String
      let photo: String?
      let hiredAt: String
      let surName: String
      let firstName: String
      let middleName: String
      let nickName: String

      enum CodingKeys: String, CodingKey {
         case id
         case organization
         case department
         case tgId = "tg_id"
         case tgName = "tg_name"
         case photo
         case hiredAt = "hired_at"
         case surName = "surname"
         case firstName = "first_name"
         case middleName = "middle_name"
         case nickName = "nickname"
      }
   }
}

struct Income: Decodable {
   let amount: Int
   let frozen: Int
   let sent: Int
   let received: Int
   let cancelled: Int
}

struct Distr: Codable {
   let amount: Int
   let expireDate: String
   let frozen: Int
   let sent: Int
   let received: Int
   let cancelled: Int

   enum CodingKeys: String, CodingKey {
      case amount
      case expireDate = "expire_date"
      case frozen
      case sent
      case received
      case cancelled
   }
}

struct Balance: Decodable {
   let income: Income
   let distr: Distr
}

protocol ApiProtocol {
   var apiEngine: ApiEngineProtocol? { get set }
}

class BaseApiWorker<In, Out>: ApiProtocol, WorkerProtocol {
   var apiEngine: ApiEngineProtocol?

   init(apiEngine: ApiEngineProtocol) {
      self.apiEngine = apiEngine
   }

   func doAsync(work: Work<In, Out>) {
      fatalError()
   }
}

final class AuthApiWorker: BaseApiWorker<String, AuthResult> {
   override func doAsync(work: Work<String, AuthResult>) {
      guard let loginName = work.input else { return }

      apiEngine?
         .process(endpoint: TeamForceEndpoints.AuthEndpoint(
            body: ["type": "authorize",
                   "login": loginName]
         ))
         .done { result in
            guard
               let xId = result.response?.headerValueFor("X-ID"),
               let xCode = result.response?.headerValueFor("X-Code")
            else {
               work.fail(())
               return
            }

            work.success(result: AuthResult(xId: xId, xCode: xCode))
         }
         .catch { _ in
            work.fail(())
         }
   }
}
