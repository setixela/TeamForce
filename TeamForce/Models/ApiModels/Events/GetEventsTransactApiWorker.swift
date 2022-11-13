//
//  GetEventsTransactionsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 25.10.2022.
//

import ReactiveWorks

final class GetEventsTransactApiWorker: BaseApiWorker<(String, Pagination), [FeedElement]> {
   override func doAsync(work: Wrk) {
      guard let request = work.input
      else {
         work.fail()
         return
      }

      let endpoint = TeamForceEndpoints.EventsTransactions(
         offset: request.1.offset,
         limit: request.1.limit,
         headers: [ "Authorization": request.0 ]
      )
      
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let feeds: [FeedElement] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: feeds)
         }
         .catch { _ in
            work.fail()
         }
   }
}
