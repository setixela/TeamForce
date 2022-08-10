//
//  GetTransactionByIdUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 10.08.2022.
//

import Foundation
import ReactiveWorks

struct GetTransactionByIdUseCase: UseCaseProtocol {
   let getTransactionByIdApiModel: GetTransactionByIdApiWorker

    func work() -> Work<TransactionRequest, Transaction> {
        getTransactionByIdApiModel.work
    }
}
