//
//  VerifyApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import Foundation

struct VerifyEvent: NetworkEventProtocol {
    var request: Event<VerifyRequest>?
    var success: Event<VerifyResultBody>?
    var error: Event<ApiEngineError>?
}

struct VerifyRequest {
    let xId: String
    let xCode: String
    let smsCode: String
}

struct VerifyResult {
    let type: String //  "authresult",
    let isSuccess: Bool //  false
}

struct VerifyResultBody: Codable {
    let type: String
    let isSuccess: Bool
    let token: String
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "sessionid"
        case isSuccess = "is_success"
        case type
        case token
    }
}

final class VerifyApiModel: BaseApiModel<VerifyEvent> {
    override func start() {
        onEvent(\.request) { [weak self] verifyRequest in
            self?.apiEngine?
                .process(endpoint: TeamForceEndpoints.VerifyEndpoint(
                    body: ["type": "authcode",
                           "code": verifyRequest.smsCode],
                    headers: ["X-ID": verifyRequest.xId,
                              "X-Code": verifyRequest.xCode]))
                .done { result in
                    let decoder = DataToDecodableParser()

                    guard
                        let data = result.data,
                        let resultBody: VerifyResultBody = decoder.parse(data)
                    else {
                        self?.sendEvent(\.error, .unknown)
                        return
                    }

                    self?.sendEvent(\.success, resultBody)
                }
                .catch { _ in
                    self?.sendEvent(\.error, .unknown)
                }
        }
    }
}


