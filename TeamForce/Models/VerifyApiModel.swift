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

final class VerifyApiModel: BaseModel, Communicable, ApiModelProtocol {
    var apiEngine: ApiEngineProtocol?

    var eventsStore: VerifyEvent = .init()

    override func start() {
        onEvent(\.request) { [weak self] verifyRequest in
            self?.apiEngine?
                .process(endpoint: TeamForceEndpoints.VerifyEndpoint(body: ["type": "authcode",
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
