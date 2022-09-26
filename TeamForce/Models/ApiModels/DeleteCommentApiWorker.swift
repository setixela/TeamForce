//
//  DeleteCommentApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import Foundation
import ReactiveWorks

final class DeleteCommentApiWorker: BaseApiWorker<RequestWithId, Void> {
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
      let endpoint = TeamForceEndpoints.DeleteComment(
         id: String(request.id),
         headers: ["Authorization": request.token,
                   "X-CSRFToken": cookie.value]
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
