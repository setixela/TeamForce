//
//  AuthApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import Foundation

protocol NetworkEventProtocol: InitProtocol {
    associatedtype Request
    associatedtype Result
    associatedtype Error

    var sendRequest: Event<Request>? { get set }
    var responseResult: Event<Result>? { get set }
    var responseError: Event<Error>? { get set }
}

struct AuthEvent: NetworkEventProtocol {
    var sendRequest: Event<String>?
    var responseResult: Event<AuthResult>?
    var responseError: Event<ApiEngineError>?
}

struct VerifyEvent: NetworkEventProtocol {
    var sendRequest: Event<VerifyRequest>?
    var responseResult: Event<VerifyResultBody>?
    var responseError: Event<ApiEngineError>?
}

final class AuthApiModel: BaseModel, Communicable {
    private let apiEngine = ApiEngine()

    var eventsStore: AuthEvent = .init()

    override func start() {
        onEvent(\.sendRequest) { [weak self] loginName in
            self?.apiEngine
                .process(endpoint: TeamForceEndpoints.AuthEndpoint(
                    body: ["type": "authorize",
                           "login": loginName]
                ))
                .done { result in
                    guard
                        let xId = result.response?.headerValueFor("X-ID"),
                        let xCode = result.response?.headerValueFor("X-Code")
                    else {
                        self?.sendEvent(\.responseError, .unknown)
                        return
                    }
                    
                    self?.sendEvent(\.responseResult, AuthResult(xId: xId, xCode: xCode))
                }
                .catch { error in
                    self?.sendEvent(\.responseError, .error(error))
                }
        }
    }
}

final class VerifyApiModel: BaseModel, Communicable {
    private let apiEngine = ApiEngine()

    var eventsStore: VerifyEvent = .init()

    override func start() {
        onEvent(\.sendRequest) { [weak self] verifyRequest in
            self?.apiEngine
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
                        self?.sendEvent(\.responseError, .unknown)
                        return
                    }

                    self?.sendEvent(\.responseResult, resultBody)
                }
                .catch { _ in
                    self?.sendEvent(\.responseError, .unknown)
                }
        }
    }
}

struct DataToDecodableParser {
    func parse<T: Decodable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()

        guard
            let result = try? decoder.decode(T.self, from: data)
        else {
            return nil
        }

        return result
    }
}
