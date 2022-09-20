//
//  PressLikeApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.09.2022.
//

import Foundation
import ReactiveWorks
struct PressLikeRequest {
   let token: String
   let likeKind: Int
   let transactionId: Int
}

final class PressLikeApiWorker: BaseApiWorker<PressLikeRequest, Void> {
   override func doAsync(work: Work<PressLikeRequest, Void>) {
      let cookieName = "csrftoken"

      guard
         let request = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }

      apiEngine?
         .process(endpoint:
            TeamForceEndpoints.PressLike(
               headers: [
                  "Authorization": request.token,
                  "X-CSRFToken": cookie.value
               ], body: [
                  "like_kind": request.likeKind,
                  "transaction": request.transactionId
               ]))
         .done { result in
//            let str = String(decoding: result.data!, as: UTF8.self)
//            print(str)
//            print("response status \(String(describing: result.response))")
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
