//
//  GetProfileApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import Foundation
import PromiseKit

struct ProfileApiEvent: NetworkEventProtocol {
    var request: Event<TokenRequest>?
    var response: Event<Promise<UserData>>?
    var error: Event<ApiEngineError>?
}

final class GetProfileApiModel: BaseApiModel<ProfileApiEvent> {
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
