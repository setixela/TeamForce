//
//  HistoryScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryScenarioEvents {
   let loadHistoryForCurrentUser: VoidWork<UserData?>

   let presentAllTransactions: VoidWork<Void>
   let presentSentTransactions: VoidWork<Void>
   let presentRecievedTransaction: VoidWork<Void>
   let presentDetailView: VoidWork<(IndexPath, Int)>
   let cancelTransaction: VoidWork<Int>
   
   let pagination: VoidWork<Bool>
}

final class HistoryScenario<Asset: AssetProtocol>:
   BaseScenario<HistoryScenarioEvents, HistoryState, HistoryWorks<Asset>>
{
   override func start() {
      works.retainer.cleanAll()
      
      events.loadHistoryForCurrentUser
         .doNext(works.initStorage)
         .doNext(works.getSegmentId)
         .doNext(works.getTransactionsBySegment)
         .onSuccess(setState) { .presentAllTransactions($0) }

      events.presentAllTransactions
         .doVoidNext(works.getAllTransactItems)
         .onSuccess(setState) { .presentAllTransactions($0) }

      events.presentSentTransactions
         .doVoidNext(works.getSentTransactItems)
         .onSuccess(setState) { .presentSentTransactions($0) }

      events.presentRecievedTransaction
         .doVoidNext(works.getRecievedTransactItems)
         .onSuccess(setState) { .presentRecievedTransaction($0) }
      
      events.presentDetailView
         .doNext(works.getTransactionByRowNumber)
         .onSuccess(setState) { .presentDetailView($0)}
      
      events.cancelTransaction
         .doNext(works.cancelTransactionById)
         .onSuccess(setState) { .cancelTransaction }
         .onFail {
            print("can not cancel transaction")
         }
      
      events.pagination
         .doNext(works.pagination)
         .onSuccess(setState) { .presentAllTransactions($0) } 
   }
}
