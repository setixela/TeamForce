//
//  GetBalanceApiModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import Foundation
import ReactiveWorks

struct BalanceApiEvent: NetworkEventProtocol {
    var request: Event<TokenRequest>?
    var success: Event<Balance>?
    var error: Event<ApiEngineError>?
}

final class GetBalanceApiWorker: BaseApiWorker<String, Balance> {
    override func doAsync(work: Wrk) {
        apiEngine?
            .process(endpoint: TeamForceEndpoints.BalanceEndpoint(headers: [
                "Authorization": work.input ?? "",
            ]))
            .done { result in
                let decoder = DataToDecodableParser()

                guard
                    let data = result.data,
                    let balance: Balance = decoder.parse(data)
                else {
                    work.fail(())
                    return
                }

                work.success(result: balance)
            }
            .catch { _ in
                work.fail(())
            }
    }
}
