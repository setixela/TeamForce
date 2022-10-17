//
//  VerifyApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import Foundation
import ReactiveWorks

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

final class VerifyApiModel: BaseApiWorker<VerifyRequest, VerifyResultBody> {
    override func doAsync(work: Work<VerifyRequest, VerifyResultBody>) {
        guard let verifyRequest = work.input else { return }

        apiEngine?
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
                    work.fail()
                    return
                }

                work.success(result: resultBody)
            }
            .catch { _ in
                work.fail()
            }
    }
}
