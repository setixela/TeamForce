//
//  GetTransactionsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 04.08.2022.
//

import Foundation
import ReactiveWorks

struct Transaction: Codable {
    let id: Int
    let sender: String
    let recipient: String
    let status: String
    let transactionClass: String
    let expireToCancel: String
    let amount: String
    let createdAt: String
    let updatedAt: String
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sender
        case recipient
        case status
        case transactionClass = "transaction_class"
        case expireToCancel = "expire_to_cancel"
        case amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case reason
    }
}

struct GetTransactionsApiEvent: NetworkEventProtocol {
    var request: Event<TokenRequest>?
    var success: Event<[Transaction]>?
    var error: Event<ApiEngineError>?
}

final class GetTransactionsApiWorker: BaseApiWorker<String, [Transaction]> {
    override func doAsync(work: Wrk) {
        apiEngine?
            .process(endpoint: TeamForceEndpoints.GetTransactions(headers: [
                "Authorization": work.input ?? "",
            ]))
            .done { result in
                let decoder = DataToDecodableParser()
                guard
                    let data = result.data,
                    let transactions: [Transaction] = decoder.parse(data)
                else {
                    work.fail(())
                    return
                }
                work.success(result: transactions)
            }
            .catch { _ in
                work.fail(())
            }
    }
}
