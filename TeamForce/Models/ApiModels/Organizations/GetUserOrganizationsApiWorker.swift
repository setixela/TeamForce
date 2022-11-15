//
//  GetUserOrganizationsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import Foundation
import ReactiveWorks

struct Organization: Codable {
   let name: String?
   let id: Int
}

final class GetUserOrganizationsApiWorker: BaseApiWorker<String, [Organization]> {
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
         .process(endpoint: TeamForceEndpoints.UserOrganizations(
            headers: [
            "Authorization": token,
            "X-CSRFToken": cookie.value
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let organizations: [Organization] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: organizations)
         }
         .catch { _ in
            work.fail()
         }
   }
}

