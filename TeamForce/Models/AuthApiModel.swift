//
//  AuthApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import Foundation
import PromiseKit

protocol NetworkEventProtocol: InitProtocol {
    associatedtype Request
    associatedtype Result
    associatedtype Error

    var request: Event<Request>? { get set }
    var response: Event<Result>? { get set }
    var error: Event<Error>? { get set }
}

struct AuthEvent: NetworkEventProtocol {
    var request: Event<String>?
    var response: Event<AuthResult>?
    var error: Event<ApiEngineError>?
}

struct VerifyEvent: NetworkEventProtocol {
    var request: Event<VerifyRequest>?
    var response: Event<VerifyResultBody>?
    var error: Event<ApiEngineError>?
}

struct ProfileApiEvent: NetworkEventProtocol {
    var request: Event<GetProfileRequest>?
    var response: Event<Promise<User>>?
    var error: Event<ApiEngineError>?
}

struct GetProfileRequest {
    let token: String
}

struct User: Codable {
    let userName: String
    let profile: Profile

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case profile
    }

    struct Profile: Codable {
        let id: Int
        let organization: String
        let department: String
        let tgId: String
        let tgName: String
        let photo: String
        let hiredAt: String
        let surName: String
        let firstName: String
        let middleName: String
        let nickName: String

        enum CodingKeys: String, CodingKey {
            case id
            case organization
            case department
            case tgId = "tg_id"
            case tgName = "tg_name"
            case photo
            case hiredAt = "hired_at"
            case surName = "surname"
            case firstName = "first_name"
            case middleName = "middle_name"
            case nickName = "nickname"
        }
    }
}

final class AuthApiModel: BaseModel, Communicable {
    private let apiEngine = ApiEngine()

    var eventsStore: AuthEvent = .init()

    override func start() {
        onEvent(\.request) { [weak self] loginName in
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
                        self?.sendEvent(\.error, .unknown)
                        return
                    }

                    self?.sendEvent(\.response, AuthResult(xId: xId, xCode: xCode))
                }
                .catch { error in
                    self?.sendEvent(\.error, .error(error))
                }
        }
    }
}

final class VerifyApiModel: BaseModel, Communicable {
    private let apiEngine = ApiEngine()

    var eventsStore: VerifyEvent = .init()

    override func start() {
        onEvent(\.request) { [weak self] verifyRequest in
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
                        self?.sendEvent(\.error, .unknown)
                        return
                    }

                    self?.sendEvent(\.response, resultBody)
                }
                .catch { _ in
                    self?.sendEvent(\.error, .unknown)
                }
        }
    }
}

final class GetProfileApiModel: BaseModel, Communicable {
    private let apiEngine = ApiEngine()

    var eventsStore: ProfileApiEvent = .init()

    override func start() {
        onEvent(\.request) { [weak self] request in
            self?.sendEvent(\.response, Promise { seal in
                self?.apiEngine
                    .process(endpoint: TeamForceEndpoints.ProfileEndpoint(headers: [
                        "Authorization": "Token " + request.token,
                    ]))
                    .done { result in
                        let decoder = DataToDecodableParser()

                        guard
                            let data = result.data,
                            let user: User = decoder.parse(data)
                        else {
                            seal.reject(ApiEngineError.unknown)
                            return
                        }
                        seal.fulfill(user)
                    }
                    .catch { _ in
                        seal.reject(ApiEngineError.unknown)
                    }
            })
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
