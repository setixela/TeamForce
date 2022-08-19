//
//  HistoryScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryScenarioEvents {
   let segmentContorlEvent: VoidWork<Int>
}

final class HistoryScenario<Asset: AssetProtocol>:
   BaseScenario<HistoryScenarioEvents, HistoryState, HistoryWorks<Asset>>
{
   override func start(setState: @escaping (HistoryState) -> Void) {
      works.loadProfile
         .doAsync()
         .onFail {
            setState(.loadProfilError)
         }
         .doNext(work: works.getTransactions)
         .onFail {
            setState(.loadTransactionsError)
         }
         .doInput(0)
         .doNext(work: works.filterTransactions)
         .onSuccess {
            setState(.present($0))
         }

      events.segmentContorlEvent
         .doNext(work: works.filterTransactions)
         .onSuccess {
            setState(.present($0))
         }
   }
}
