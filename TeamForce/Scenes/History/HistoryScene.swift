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
   Eventable
{
   //
   typealias Events = MainSceneEvents
   typealias State = StackState

   var events: EventsStore = .init()

   private lazy var viewModels = HistoryViewModels<Design>()

   lazy var scenario: Scenario = HistoryScenario(
      works: HistoryWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: HistoryScenarioEvents(
         presentAllTransactions: viewModels.segmentedControl.onEvent(\.selected0),
         presentSentTransactions: viewModels.segmentedControl.onEvent(\.selected2),
         presentRecievedTransaction: viewModels.segmentedControl.onEvent(\.selected1),
         presentDetailView: viewModels.tableModel.on(\.didSelectRow),
         cancelTransaction: viewModels.presenter.on(\.cancelButtonPressed),
         pagination: viewModels.tableModel.on(\.pagination)
      )
   )

   private lazy var activityIndicator = ActivityIndicator<Design>()
   private lazy var errorBlock = CommonErrorBlock<Design>()

   // MARK: - Start

   override func start() {
      configure()

      viewModels.tableModel
         .presenters(
            viewModels.presenter.transactToHistoryCell,
            SpacerPresenter.presenter
         )

      viewModels.tableModel
         .on(\.didScroll) { [weak self] in
            self?.send(\.didScroll, $0)
         }
         .on(\.willEndDragging) { [weak self] in
            self?.send(\.willEndDragging, $0)
         }
         .activateRefreshControl(color: Design.color.iconBrand)
         .on(\.refresh, self) {
            $0.send(\.userDidLoad, nil)
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
         Spacer()
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

   case cancelTransaction
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
         activityIndicator.hidden(true)
         scenario.start()
      //
      case .presentAllTransactions(let value):
         errorBlock.hidden(true)
         activityIndicator.hidden(true)
         viewModels.tableModel
            .itemSections(value.addedSpacer(size: Grid.x80.value))
      //
      case .presentSentTransactions(let value):
         errorBlock.hidden(true)
         activityIndicator.hidden(true)
         viewModels.tableModel
            .itemSections(value.addedSpacer(size: Grid.x80.value))
      //
      case .presentRecievedTransaction(let value):
         errorBlock.hidden(true)
         activityIndicator.hidden(true)
         viewModels.tableModel
            .itemSections(value.addedSpacer(size: Grid.x80.value))
      //
      case .presentDetailView(let value):
         ProductionAsset.router?.route(.presentModally(.automatic),
                                       scene: \.sentTransactDetails,
                                       payload: value)
      case .cancelTransaction:
         scenario.start()
         print("transaction cancelled")
      }
   }
}

extension Array where Element: TableItemsSection {
   func addedSpacer(size: CGFloat) -> [TableItemsSection] {
      last?.items.append(SpacerItem(size: size))
      return self
   }
}
