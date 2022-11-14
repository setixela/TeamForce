//
//  NotificationReadWithId.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 14.11.2022.
//

import ReactiveWorks
import Foundation


final class NotificationReadWithIdApiWorker: BaseApiWorker<RequestWithId, Void> {
   
   struct NotificationReadBody: Codable {
      let read: Bool
   }
   
   override func doAsync(work: Work<RequestWithId, Void>) {
      let cookieName = "csrftoken"
      
      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail()
         return
      }
      let body = NotificationReadBody(read: true)
      let jsonData = try? JSONEncoder().encode(body)
      let endpoint = TeamForceEndpoints.NotificationReadWithId(
         id: String(request.id),
         headers: ["Authorization": request.token,
                   "X-CSRFToken": cookie.value,
                   "Content-Type": "application/json"],
         jsonData: jsonData
      )

      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}

