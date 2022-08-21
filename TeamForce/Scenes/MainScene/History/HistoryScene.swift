//
//  HistoryScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import ReactiveWorks
import UIKit

// MARK: - HistoryScene

final class HistoryScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Assetable,
   Stateable,
   Scenaryable
{
   //
   typealias State = StackState

   private lazy var viewModels = HistoryViewModels<Design>()

   lazy var scenario = HistoryScenario(
      works: HistoryWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: HistoryScenarioEvents(
         presentAllTransactions: viewModels.segmentedControl.onEvent(\.selected1),
         presentSentTransactions: viewModels.segmentedControl.onEvent(\.selected2),
         presentRecievedTransaction: viewModels.segmentedControl.onEvent(\.selected3)
      )
   )

   // MARK: - Start

   override func start() {
      configure()

      scenario.start()

      viewModels.tableModel
         .set(.presenters([
            HistoryPresenters<Design>.transactToHistoryCell,
         ]))
   }
}

// MARK: - Configure presenting

private extension HistoryScene {
   func configure() {
      set_axis(.vertical)
      set_arrangedModels([
         viewModels.segmentedControl,
         viewModels.tableModel,
         Spacer(88),
      ])
   }
}

enum HistoryState {
   case loadProfilError
   case loadTransactionsError

   case presentAllTransactions([TableItemsSection])
   case presentSentTransactions([TableItemsSection])
   case presentRecievedTransaction([TableItemsSection])
}

extension HistoryScene: SceneStateProtocol {
   func setState(_ state: HistoryState) {
      switch state {
      case .loadProfilError:
         break
      case .loadTransactionsError:
         break
      case .presentAllTransactions(let value):
         viewModels.tableModel
            .set(.itemSections(value))
      case .presentSentTransactions(let value):
         viewModels.tableModel
            .set(.itemSections(value))
      case .presentRecievedTransaction(let value):
         viewModels.tableModel
            .set(.itemSections(value))
      }
   }
}
