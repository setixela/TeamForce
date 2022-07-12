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
    var success: Event<Result>? { get set }
    var error: Event<Error>? { get set }
}

struct AuthEvent: NetworkEventProtocol {
    var request: Event<String>?
    var success: Event<AuthResult>?
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
    let sent: Int
    let received: Int
    let cancelled: Int
}

struct Distr: Codable {
    let amount: Int
    let expireDate: String
    let frozen: Int
    let sent: Int
    let received: Int
    let cancelled: Int

    enum CodingKeys: String, CodingKey {
        case amount
        case expireDate = "expire_date"
        case frozen
        case sent
        case received
        case cancelled
    }
}

struct Balance: Decodable {
    let income: Income
    let distr: Distr
}

protocol ApiModelProtocol: ModelProtocol,
    InitProtocol,
    Communicable where Events: NetworkEventProtocol
{
    var apiEngine: ApiEngineProtocol? { get set }
}

class BaseApiModel<Events: NetworkEventProtocol>: BaseModel, ApiModelProtocol {
    var apiEngine: ApiEngineProtocol?
    var eventsStore: Events = .init()

    required init(apiEngine: ApiEngineProtocol) {
        super.init()
        self.apiEngine = apiEngine
    }

    required init() {
        fatalError()
    }
}

final class AuthApiModel: BaseApiModel<AuthEvent> {
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

                    self?.sendEvent(\.success, AuthResult(xId: xId, xCode: xCode))
                }
                .catch { error in
                    self?.sendEvent(\.error, .error(error))
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
