//
//  CancelTransactionByIdApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import Foundation
import ReactiveWorks

final class CancelTransactionByIdApiWorker: BaseApiWorker<RequestWithId, Void> {
   override func doAsync(work: Work<RequestWithId, Void>) {
      let cookieName = "csrftoken"
      
      guard
         let transactionRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail(())
         return
      }
      let endpoint = TeamForceEndpoints.CancelTransaction(
         id: String(transactionRequest.id),
         headers: ["Authorization": transactionRequest.token,
                   "X-CSRFToken": cookie.value],
                   body: ["status" : "D"]
      )
      print("endpoint is \(endpoint)")
      apiEngine?
         .processPUT(endpoint: endpoint)
         .done { result in
            work.success(result: ())
         }
         .catch { _ in
            work.fail(())
         }
   }
}
