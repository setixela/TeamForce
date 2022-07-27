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
    var error: Event<ApiEngineError>?
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
                    self?.sendEvent(\.success, nil)
                }
                .catch { _ in
                    self?.sendEvent(\.error, .unknown)
                }
        }
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
