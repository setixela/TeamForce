//
//  HistoryScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryScenarioEvents {
   let presentAllTransactions: VoidWork<Void>
   let presentSentTransactions: VoidWork<Void>
   let presentRecievedTransaction: VoidWork<Void>
   let presentDetailView: VoidWork<(IndexPath, Int)>
   let cancelTransaction: VoidWork<Int>
}

final class HistoryScenario<Asset: AssetProtocol>:
   BaseScenario<HistoryScenarioEvents, HistoryState, HistoryWorks<Asset>>
{
   override func start() {

      works.loadProfile
         .doAsync()
         .onFail(setState, .loadProfilError)
         .doNext(work: works.getTransactions)
         .onFail(setState, .loadTransactionsError)
         .doVoidNext(works.getAllTransactItems)
         .onSuccess(setState) { .presentAllTransactions($0) }

      events.presentAllTransactions
         .doNext(work: works.getAllTransactItems)
         .onSuccess(setState) { .presentAllTransactions($0) }

      events.presentSentTransactions
         .doNext(work: works.getSentTransactItems)
         .onSuccess(setState) { .presentSentTransactions($0) }

      events.presentRecievedTransaction
         .doNext(work: works.getRecievedTransactItems)
         .onSuccess(setState) { .presentRecievedTransaction($0) }
      
      events.presentDetailView
         .doNext(work: works.getTransactionByRowNumber)
         .onSuccess(setState) { .presentDetailView($0)}
      
      events.cancelTransaction
         .doNext(work: works.cancelTransactionById)
         .onSuccess(setState) { .cancelTransaction }
         .onFail {
            print("can not cancel transaction")
         }
   }
}
