//
//  SendCoinApiModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 27.07.2022.
//

import Foundation

struct SendCoinRequest {
    let token: String
    let csrfToken: String
    let recipient: Int
    let amount: String
    let reason: String
}

struct SendCoinEvent: NetworkEventProtocol {
    var request: Event<SendCoinRequest>?
    var success: Event<Any?>?
    var error: Event<String>?
}

final class SendCoinApiModel: BaseApiModel<SendCoinEvent> {
    override func start() {
        
        onEvent(\.request) { [weak self] sendCoinRequest in
            print(sendCoinRequest)
            let cookieName = "csrftoken"
            guard let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName }) else {
                print("No csrf cookie")
                return
            }
            
            self?.apiEngine?
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
                            self?.sendEvent(\.error, errorArray[0])
                            return
                        }
                    }
                    self?.sendEvent(\.success, nil)
                }
                .catch { error in
                    print("error coin sending: \(error)")
                    self?.sendEvent(\.error, ".error(error)")
                }
        }
    }
}
