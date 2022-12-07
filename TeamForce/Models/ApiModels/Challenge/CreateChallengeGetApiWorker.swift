//
//  CreateChallengeGetApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.12.2022.
//

import Foundation
import ReactiveWorks

struct ChallengeType: Codable {
   let `default`: Int?
   let voting: Int?
}

struct CreateChallengeSettings: Codable {
   let types: ChallengeType?
   let showParticipants: Bool?
   let severalReports: Bool?
}

final class CreateChallengeGetApiWorker: BaseApiWorker<String, CreateChallengeSettings> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let token = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }
      //let body = request.body.dictionary ?? [:]

      let endpoint = TeamForceEndpoints.CreateChallengeGet(
         headers: [
            "Authorization": token,
            "X-CSRFToken": cookie.value
         ]
         //body: body
      )
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let settings: CreateChallengeSettings = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: settings)
         }
         .catch { _ in
            work.fail()
         }
   }
}
