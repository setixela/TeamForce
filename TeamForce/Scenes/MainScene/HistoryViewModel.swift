//
//  HistoryViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 04.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryViewEvent: InitProtocol {}

final class HistoryViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState
   
   var eventsStore: HistoryViewEvent = .init()

   // MARK: - Frame Cells

   // MARK: - Services

   private lazy var getTransactionsUseCase = Asset.apiUseCase.getTransactions.work()
   override func start() {
      print("transactions started")
      getTransactionsUseCase
         .doAsync()
         .onSuccess { transactions in
            print(transactions)
         }
         .onFail {
            print("transactions not loaded")
         }
   }
}
