//
//  GetUsersListApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.08.2022.
//

import UIKit
import ReactiveWorks

final class GetUsersListApiWorker: BaseApiWorker<String, [FoundUser]> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"
      
      guard
         let token = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail()
         return
      }
      
      apiEngine?
         .process(endpoint: TeamForceEndpoints.UsersList(
            body: ["get_users": true],
            headers: ["Authorization": token,
                      "X-CSRFToken": cookie.value
                     ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let usersList: [FoundUser] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: usersList)
         }
         .catch { _ in
            work.fail()
         }
   }
}
