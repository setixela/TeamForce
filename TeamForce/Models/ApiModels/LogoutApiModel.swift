//
//  LogoutApiModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.07.2022.
//

import Foundation

struct LogoutApiEvent: NetworkEventProtocol {
    var request: Event<TokenRequest>?
    var success: Event<Any?>?
    var error: Event<Error>?
}

final class LogoutApiModel: BaseApiModel<LogoutApiEvent> {
    override func start() {
        onEvent(\.request) { [weak self] request in
            self?.apiEngine?
                .process(endpoint: TeamForceEndpoints.Logout())
                .done { _ in //result in
                    print("Logout happened1")
                    self?.sendEvent(\.success, nil)
                }
                .catch { error in
                    print("Error for logout")
                    self?.sendEvent(\.error, ApiEngineError.error(error))
                }
        }
    }
}
