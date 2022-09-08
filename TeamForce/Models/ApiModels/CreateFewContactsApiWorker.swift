//
//  CreateFewContactsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 07.09.2022.
//

import Foundation
import ReactiveWorks

struct CreateFewContactsRequest {
   let token: String
   let info: [[String: Any]]
}

final class CreateFewContactsApiWorker: BaseApiWorker<CreateFewContactsRequest, Void> {
   override func doAsync(work: Work<CreateFewContactsRequest, Void>) {
      let cookieName = "csrftoken"

      guard
         let CreateFewContactsRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail(())
         return
      }
      let endpoint = TeamForceEndpoints.CreateFewContacts(
         arrayBody: CreateFewContactsRequest.info,
         headers: ["Authorization": CreateFewContactsRequest.token,
                   "X-CSRFToken": cookie.value]
      )
      print("endpoint is \(endpoint)")
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
//            let str = String(decoding: result.data!, as: UTF8.self)
//            print(str)
//            print("response status \(result.response)")
            work.success(result: ())
         }
         .catch { _ in
            work.fail(())
         }
   }
}
