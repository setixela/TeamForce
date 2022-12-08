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

struct Privilege: Codable {
   let roleName: String
   let departmentName: String?

   enum CodingKeys: String, CodingKey {
      case roleName = "role_name"
      case departmentName = "department_name"
   }
}

struct UserData: Codable {
   let userName: String
   let profile: Profile
   let privileged: [Privilege]

   enum CodingKeys: String, CodingKey {
      case userName = "username"
      case profile
      case privileged
   }

   struct Profile: Codable {
      let id: Int
      let contacts: [Contact]?
      let organization: String
      let organizationId: Int
      let department: String
      let tgId: String?
      let tgName: String?
      let photo: String?
      let hiredAt: String?
      let surName: String?
      let firstName: String?
      let middleName: String?
      let nickName: String?
      let jobTitle: String?

      enum CodingKeys: String, CodingKey {
         case id
         case contacts
         case organization
         case organizationId = "organization_id"
         case department
         case tgId = "tg_id"
         case tgName = "tg_name"
         case photo
         case hiredAt = "hired_at"
         case surName = "surname"
         case firstName = "first_name"
         case middleName = "middle_name"
         case nickName = "nickname"
         case jobTitle = "job_title"
      }
   }
}

struct Contact: Codable {
   let id: Int
   let contactType: String
   let contactId: String

   enum CodingKeys: String, CodingKey {
      case id
      case contactType = "contact_type"
      case contactId = "contact_id"
   }
}

extension UserData {
   var userEmail: String? {
      profile.contacts?.first(where: {
         $0.contactType == "@"
      })?.contactId
   }

   var userPhone: String? {
      profile.contacts?.first(where: {
         $0.contactType == "P"
      })?.contactId
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
   let expireDate: String?
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

enum Account {
   case telegram
   case email
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

struct SoloOrgResult: Codable {
   let status: String?
   let organizations: [OrganizationAuth]
}

struct OrganizationAuth: Codable {
   let userId: Int
   let organizationId: Int
   let organizationName: String?
   let organizationPhoto: String?

   enum CodingKeys: String, CodingKey {
      case userId = "user_id"
      case organizationId = "organization_id"
      case organizationName = "organization_name"
      case organizationPhoto = "organization_photo"
   }
}

enum Auth2Result {
   case auth(AuthResult)
   case organisations([OrganizationAuth])
}

final class AuthApiWorker: BaseApiWorker<String, Auth2Result> {
   override func doAsync(work: Work<String, Auth2Result>) {
      guard let loginName = work.input else { return }

      let cookieStore = HTTPCookieStorage.shared
      for cookie in cookieStore.cookies ?? [] {
         cookieStore.deleteCookie(cookie)
      }

      apiEngine?
         .process(endpoint: TeamForceEndpoints.AuthEndpoint(
            body: ["type": "authorize",
                   "login": loginName]
         ))
         .done { result in

            if let status = result.response?.headerValueFor("login") {
               let decoder = DataToDecodableParser()

               guard
                  let data = result.data,
                  let soloOrg: SoloOrgResult = decoder.parse(data)
               else {
                  work.fail()
                  return
               }
               let res = Auth2Result.organisations(soloOrg.organizations)
               work.success(result: res)

            } else {
               guard
                  let xCode = result.response?.headerValueFor("X-Code")
               else {
                  work.fail()
                  return
               }
               let account: Account?
               let xId: String?
               if (result.response?.headerValueFor("X-Telegram")) != nil {
                  xId = result.response?.headerValueFor("X-Telegram") ?? ""
                  account = .telegram
               } else {
                  xId = result.response?.headerValueFor("X-Email") ?? ""
                  account = .email
               }

               guard
                  let xId = xId,
                  let account = account
               else { return }
               let res = Auth2Result.auth(AuthResult(xId: xId, xCode: xCode, account: account))
               work.success(result: res)
            }
         }
         .catch { _ in
            work.fail()
         }
   }
}
