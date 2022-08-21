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
         presentAllTransactions: viewModels.segmentedControl.onEvent(\.selected0),
         presentSentTransactions: viewModels.segmentedControl.onEvent(\.selected1),
         presentRecievedTransaction: viewModels.segmentedControl.onEvent(\.selected2)
      )
   )

   // MARK: - Start

   override func start() {
      configure()

      scenario.start()

      viewModels.tableModel
         .set(.presenters([
            HistoryPresenters<Design>.transactToHistoryCell,
            SpacerPresenter.presenter
         ]))
   }
}

// MARK: - Configure presenting

private extension HistoryScene {
   func configure() {
      set_axis(.vertical)
      set_arrangedModels([
         viewModels.segmentedControl,
         Grid.x16.spacer,
         viewModels.tableModel,
         //Spacer(88),
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

extension HistoryScene: StateMachine {
   func setState(_ state: HistoryState) {
      switch state {
      case .loadProfilError:
         break
      case .loadTransactionsError:
         break
      case .presentAllTransactions(let value):
         viewModels.tableModel
            .set(.itemSections(value.addedSpacer(size: Grid.x80.value)))
      case .presentSentTransactions(let value):
         viewModels.tableModel
            .set(.itemSections(value.addedSpacer(size: Grid.x80.value)))
      case .presentRecievedTransaction(let value):
         viewModels.tableModel
            .set(.itemSections(value.addedSpacer(size: Grid.x80.value) ))
      }
   }
}

extension Array where Element: TableItemsSection {
   func addedSpacer(size: CGFloat) -> [TableItemsSection] {
      last?.items.append(SpacerItem(size: size))
      return self
   }
}
