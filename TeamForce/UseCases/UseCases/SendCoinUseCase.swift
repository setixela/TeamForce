//
//  SendCoinUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 03.08.2022.
//

import Foundation

struct SendCoinUseCase: UseCaseProtocol {
   let sendCoinApiModel: SendCoinApiWorker

    func work() -> Work<SendCoinRequest, Void> {
        sendCoinApiModel.work
    }
}
