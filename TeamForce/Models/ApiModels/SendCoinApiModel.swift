//
//  SendCoinApiModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import Foundation
import ReactiveWorks
import UIKit

struct SendCoinRequest {
   let token: String
   let csrfToken: String
   let recipient: Int
   let amount: String
   let reason: String
   let isAnonymous: Bool
   let photo: UIImage?
   let tags: String?
}

protocol Failuring {
   associatedtype Failure: Error
}

final class SendCoinApiWorker: BaseApiWorker<SendCoinRequest, Void> {
   override func doAsync(work: Work<SendCoinRequest, Void>) {
      let cookieName = "csrftoken"

      guard
         let sendCoinRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail(())
         return
      }

      let body: [String: Any] = [
         "recipient": sendCoinRequest.recipient,
         "amount": sendCoinRequest.amount,
         "reason": sendCoinRequest.reason,
         "is_anonymous": sendCoinRequest.isAnonymous,
         "tags": sendCoinRequest.tags.string
      ]

      if let photo = sendCoinRequest.photo {
         /// body["photo": photo]

         apiEngine?
            .processWithImage(endpoint: TeamForceEndpoints.SendCoin(
               body: body,
               headers: [
                  "Authorization": sendCoinRequest.token,
                    "X-CSRFToken": cookie.value
               ]),
            image: photo)
            .done { result in
               if let response = result.response as? HTTPURLResponse {
                  if response.statusCode == 400 {
                     print("400 happened")
                     guard let data = result.data else {
                        work.fail(())
                        return
                     }

                     let errorArray = try JSONSerialization.jsonObject(with: data) as? [String]

                     work.fail(())
                     return
                  }
               }
               work.success(result: ())
            }
            .catch { error in
               print("error coin sending: \(error)")
               work.fail(())
            }
      } else {
         apiEngine?
            .process(endpoint: TeamForceEndpoints.SendCoin(
               body: body,
               headers: [
                  "Authorization": sendCoinRequest.token,
                  "X-CSRFToken": cookie.value,
               ]))
            .done { result in
               if let response = result.response as? HTTPURLResponse {
                  if response.statusCode == 400 {
                     print("400 happened")
                     guard let data = result.data else {
                        work.fail(())
                        return
                     }

                     let errorArray = try JSONSerialization.jsonObject(with: data) as? [String]

                     work.fail(errorArray?.first)
                     return
                  }
               }
               work.success(result: ())
            }
            .catch { error in
               print("error coin sending: \(error)")
               work.fail(())
            }
      }
   }
}

extension SendCoinApiWorker: Failuring {
   enum Failure: Error {
      case noCookie
   }
}
