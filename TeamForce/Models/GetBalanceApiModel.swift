//
//  GetBalanceApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import Foundation

struct BalanceApiEvent: NetworkEventProtocol {
    var request: Event<TokenRequest>?
    var success: Event<Balance>?
    var error: Event<ApiEngineError>?
}

final class GetBalanceApiModel: BaseApiModel<BalanceApiEvent> {

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

                    self?.sendEvent(\.success, balance)
                }
                .catch { error in
                    self?.sendEvent(\.error, ApiEngineError.error(error))
                }
        }
    }
}
