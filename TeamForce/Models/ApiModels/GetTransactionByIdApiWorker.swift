//
//  GetTransactionByIdApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 10.08.2022.
//

import UIKit
import ReactiveWorks

//struct GetTransactionByIdApiEvent: NetworkEventProtocol {
//    var request: Event<TokenRequest>?
//    var success: Event<Transaction>?
//    var error: Event<ApiEngineError>?
//}

struct TransactionRequest {
    let token: String
    let csrfToken: String
    let id: Int
}


final class GetTransactionByIdApiWorker: BaseApiWorker<TransactionRequest, Transaction> {
    override func doAsync(work: Work<TransactionRequest, Transaction>) {
        let cookieName = "csrftoken"

        guard
            let transactionRequest = work.input,
            let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
        else {
            print("No csrf cookie")
            work.fail(())
            return
        }
        let endpoint = TeamForceEndpoints.GetTransactionById(
            id: String(transactionRequest.id),
            headers: ["Authorization": transactionRequest.token,
                      "X-CSRFToken": cookie.value]
        )
        
        apiEngine?
            .process(endpoint: endpoint)
            .done { result in
                let decoder = DataToDecodableParser()
                guard
                    let data = result.data,
                    let transaction: Transaction = decoder.parse(data)
                else {
                    work.fail(())
                    return
                }
                work.success(result: transaction)
            }
            .catch { _ in
                work.fail(())
            }
    }
}
