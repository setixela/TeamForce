//
//  GetChallengeWinnersApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 07.10.2022.
//

import Foundation
import ReactiveWorks

final class GetChallengeWinnersApiWorker: BaseApiWorker<RequestWithId, [Contender]> {
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
               let winners: [Contender] = decoder.parse(data)
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
