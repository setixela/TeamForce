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
    var request: Event<TokenRequest>?
    var response: Event<Promise<UserData>>?
    var error: Event<ApiEngineError>?
}

struct BalanceApiEvent: NetworkEventProtocol {
    var request: Event<TokenRequest>?
    var response: Event<Balance>?
    var error: Event<ApiEngineError>?
}

struct TokenRequest {
    let token: String
}

struct UserData: Codable {
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
        let photo: String?
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

struct Income: Decodable {
    let amount: Int
    let frozen: Int
    let sended: Int
    let received: Int
    let cancelled: Int
}

struct Distr: Codable {
    let amount: Int
    let expireDate: String
    let frozen: Int
    let sended: Int
    let received: Int
    let cancelled: Int

    enum CodingKeys: String, CodingKey {
        case amount
        case expireDate = "expire_date"
        case frozen
        case sended
        case received
        case cancelled
    }
}

struct Balance: Decodable {
    let income: Income
    let distr: Distr
}

protocol ApiModelProtocol: ModelProtocol, InitProtocol {
    var apiEngine: ApiEngineProtocol? { get set }
}

extension ApiModelProtocol {
    init(apiEngine: ApiEngineProtocol) {
        self.init()
        self.apiEngine = apiEngine
    }
}

final class AuthApiModel: BaseModel, Communicable, ApiModelProtocol {
    var apiEngine: ApiEngineProtocol?

    var eventsStore: AuthEvent = .init()

    override func start() {
        onEvent(\.request) { [weak self] loginName in
            self?.apiEngine?
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

                    self?.sendEvent(\.response, resultBody)
                }
                .catch { _ in
                    self?.sendEvent(\.error, .unknown)
                }
        }
    }
}

final class GetProfileApiModel: BaseModel, Communicable, ApiModelProtocol {
    var apiEngine: ApiEngineProtocol?

    var eventsStore: ProfileApiEvent = .init()

    override func start() {
        onEvent(\.request) { [weak self] request in
            self?.sendEvent(\.response, Promise { seal in
                self?.apiEngine?
                    .process(endpoint: TeamForceEndpoints.ProfileEndpoint(headers: [
                        "Authorization": "Token " + request.token,
                    ]))
                    .done { result in
                        let decoder = DataToDecodableParser()

                        guard
                            let data = result.data,
                            let user: UserData = decoder.parse(data)
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

final class GetBalanceApiModel: BaseModel, Communicable, ApiModelProtocol {
    var apiEngine: ApiEngineProtocol?

    var eventsStore: BalanceApiEvent = .init()

    override func start() {
        onEvent(\.request) { [weak self] request in
            self?.apiEngine?
                .process(endpoint: TeamForceEndpoints.BalanceEndpoint(headers: [
                    "Authorization": "Token " + request.token,
                ]))
                .done { result in
                    let decoder = DataToDecodableParser()

                    guard
                        let data = result.data,
                        let balance: Balance = decoder.parse(data)
                    else {
                        self?.sendEvent(\.error, ApiEngineError.unknown)
                        return
                    }

                    self?.sendEvent(\.response, balance)
                }
                .catch { error in
                    self?.sendEvent(\.error, ApiEngineError.error(error))
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
