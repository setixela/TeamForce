//
//  SearchUserApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.07.2022.
//

import Foundation

struct SearchUserApiEvent: NetworkEventProtocol {
    var request: Event<SearchUserRequest>?
    var success: Event<[FoundUser]>?
    var error: Event<ApiEngineError>?
}

struct SearchUserRequest {
    let data: String
    let token: String
    let csrfToken: String
}

struct SearchUserResult {
    let users: [FoundUser]
}

struct FoundUser: Codable {
    let userId: Int
    let tgName: String
    let name: String
    let surname: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case tgName = "tg_name"
        case name
        case surname
    }
}

struct SearchUserResponse: Decodable {
    var foundUsers: [FoundUser]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        foundUsers = try container.decode([FoundUser].self) // Decode just first element
    }
}

final class SearchUserApiModel: BaseApiModel<SearchUserApiEvent> {
    //
    override func start() {
        onEvent(\.request) { [weak self] searchRequest in
            print(searchRequest)
            let cookieName = "csrftoken"
            guard let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName }) else {
                print("No csrf cookie")
                return
            }

            self?.apiEngine?
                .process(endpoint: TeamForceEndpoints.SearchUser(
                    body: ["data": searchRequest.data],
                    headers: [
                        "Authorization": searchRequest.token,
                        "X-CSRFToken": cookie.value
                    ]))
                .done { result in
                    let decoder = DataToDecodableParser()

                    guard
                        let data = result.data,
                        let resultBody: [FoundUser] = decoder.parse(data)
                    else {
                        self?.sendEvent(\.error, .unknown)
                        return
                    }

                    print(resultBody)
                    self?.sendEvent(\.success, resultBody)
                }
                .catch { _ in
                    self?.sendEvent(\.error, .unknown)
                }
        }
    }
}
