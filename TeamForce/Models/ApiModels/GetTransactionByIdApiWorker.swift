//
//  GetTransactionByIdApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 10.08.2022.
//

import UIKit
import ReactiveWorks

struct RequestWithId {
   let token: String
   //   let csrfToken: String
   let id: Int
}


final class GetTransactionByIdApiWorker: BaseApiWorker<RequestWithId, Transaction> {
   override func doAsync(work: Work<RequestWithId, Transaction>) {
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
