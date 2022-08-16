//
//  GetTransactionsByPeriodApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import UIKit
import ReactiveWorks

final class GetTransactionsByPeriodApiWorker: BaseApiWorker<RequestWithId, [Transaction]> {
   override func doAsync(work: Work<RequestWithId, [Transaction]>) {
      
      guard
         let transactionRequest = work.input
      else {
         work.fail(())
         return
      }
      
      let endpoint = TeamForceEndpoints.GetTransactionByPeriod(
         id: String(transactionRequest.id),
         headers: ["Authorization": transactionRequest.token,]
      )
      
      apiEngine?
         .process(endpoint: endpoint)
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
