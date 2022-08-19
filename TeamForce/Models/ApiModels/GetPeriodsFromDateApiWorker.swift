//
//  GetPeriodsFromDateApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 19.08.2022.
//
import Foundation
import ReactiveWorks

final class GetPeriodsFromDateApiWorker: BaseApiWorker<RequestWithDate, [Period]> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"
      
      guard
         let input = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail(())
         return
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.GetPeriodsFromDate(
            body: ["from_date": input.date],
            headers: ["Authorization": input.token,
                      "X-CSRFToken": cookie.value]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let periods: [Period] = decoder.parse(data)
            else {
               work.fail(())
               return
            }
            work.success(result: periods)
         }
         .catch { _ in
            work.fail(())
         }
   }
}
