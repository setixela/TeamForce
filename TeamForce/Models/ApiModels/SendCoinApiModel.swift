//
//  SendCoinApiModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import Foundation
import ReactiveWorks

struct SendCoinRequest {
    let token: String
    let csrfToken: String
    let recipient: Int
    let amount: String
    let reason: String
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
            
        apiEngine?
            .process(endpoint: TeamForceEndpoints.SendCoin(
                body: ["recipient": sendCoinRequest.recipient,
                       "amount": sendCoinRequest.amount,
                       "reason": sendCoinRequest.reason],
                headers: ["Authorization": sendCoinRequest.token,
                          "X-CSRFToken": cookie.value]))
            .done { result in
                if let response = result.response as? HTTPURLResponse{
                    if response.statusCode == 400 {
                        print("400 happened")
                        let errorArray = try JSONSerialization.jsonObject(with: result.data!) as! [String]
                        work.fail(errorArray.first)
                        return
                    }
                }
                work.success(result: ())
            }
            .catch { error in
                print("error coin sending: \(error)")
                work.fail(error)
            }
    }
}

extension SendCoinApiWorker: Failuring {
   enum Failure: Error {
      case noCookie
   }
}

