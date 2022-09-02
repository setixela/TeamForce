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
   Scenarible,
   Communicable
{
   //
   typealias State = StackState

   var events = MainSceneEvents()

   private lazy var viewModels = HistoryViewModels<Design>()

   lazy var scenario: Scenario = HistoryScenario(
      works: HistoryWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: HistoryScenarioEvents(
         presentAllTransactions: viewModels.segmentedControl.onEvent(\.selected0),
         presentSentTransactions: viewModels.segmentedControl.onEvent(\.selected2),
         presentRecievedTransaction: viewModels.segmentedControl.onEvent(\.selected1),
         presentDetailView: viewModels.tableModel.onEvent(\.didSelectRow)
      )
   )

   private lazy var activityIndicator = ActivityIndicator<Design>()
   private lazy var errorBlock = CommonErrorBlock<Design>()

   // MARK: - Start

   override func start() {
      configure()

      viewModels.tableModel
         .set(.presenters([
            HistoryPresenters<Design>.transactToHistoryCell,
            SpacerPresenter.presenter,
         ]))

      viewModels.tableModel.onEvent(\.didScroll) { [weak self] in
         self?.sendEvent(\.didScroll, $0)
      }
      viewModels.tableModel.onEvent(\.willEndDragging) { [weak self] in
         self?.sendEvent(\.willEndDragging, $0)
      }

      setState(.initial)
   }
}

// MARK: - Configure presenting

private extension HistoryScene {
   func configure() {
      axis(.vertical)
      arrangedModels([
         viewModels.segmentedControl,
         Grid.x16.spacer,
         activityIndicator,
         errorBlock,
         viewModels.tableModel,
         // Spacer(88),
      ])
   }
}

enum HistoryState {
   case initial

   case loadProfilError
   case loadTransactionsError

   case presentAllTransactions([TableItemsSection])
   case presentSentTransactions([TableItemsSection])
   case presentRecievedTransaction([TableItemsSection])

   case presentDetailView(Transaction)
}

extension HistoryScene: StateMachine {
   func setState(_ state: HistoryState) {
      switch state {
      case .initial:
         activityIndicator.hidden(false)
         errorBlock.hidden(true)
      case .loadProfilError:
         errorBlock.hidden(false)
         scenario.start()
      //
      case .loadTransactionsError:
         errorBlock.hidden(false)
         scenario.start()
      //
      case .presentAllTransactions(let value):
         errorBlock.hidden(true)
         activityIndicator.hidden(true)
         viewModels.tableModel
            .set(.itemSections(value.addedSpacer(size: Grid.x80.value)))
      //
      case .presentSentTransactions(let value):
         errorBlock.hidden(true)
         activityIndicator.hidden(true)
         viewModels.tableModel
            .set(.itemSections(value.addedSpacer(size: Grid.x80.value)))
      //
      case .presentRecievedTransaction(let value):
         errorBlock.hidden(true)
         activityIndicator.hidden(true)
         viewModels.tableModel
            .set(.itemSections(value.addedSpacer(size: Grid.x80.value)))
      //
      case .presentDetailView(let value):
         ProductionAsset.router?.route(\.transactionDetail,
                                       navType: .presentModally(.automatic),
                                       payload: value)
      }
   }
}

extension Array where Element: TableItemsSection {
   func addedSpacer(size: CGFloat) -> [TableItemsSection] {
      last?.items.append(SpacerItem(size: size))
      return self
   }
}
