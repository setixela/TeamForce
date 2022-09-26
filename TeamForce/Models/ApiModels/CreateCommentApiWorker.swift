//
//  CreateCommentApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import Foundation
import ReactiveWorks
import UIKit

struct CreateCommentRequest {
   let token: String
   let body: CreateCommentBody?
}

struct CreateCommentBody: Codable {
   let transaction: Int
   let text: String?
}

final class CreateCommentApiWorker: BaseApiWorker<CreateCommentRequest, Void> {
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
         .process(endpoint: TeamForceEndpoints.CreateComment(headers: [
            "Authorization": request.token,
            "X-CSRFToken": cookie.value
         ], body: request.body.dictionary ?? [:]))
         .done { result in
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
