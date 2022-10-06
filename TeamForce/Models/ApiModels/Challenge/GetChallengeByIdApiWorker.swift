//
//  GetChallengeByIdApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import Foundation
import ReactiveWorks

final class GetChallengeByIdApiWorker: BaseApiWorker<RequestWithId, Challenge> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let input = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.GetChallengeById(
            id: String(input.id),
            headers: [
               "Authorization": input.token,
               "X-CSRFToken": cookie.value
            ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let challenge: Challenge = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: challenge)
         }
         .catch { _ in
            work.fail()
         }
   }
}
