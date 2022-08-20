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
         segmentContorlEvent: viewModels.segmentedControl.onEvent(\.segmentChanged)
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
         Spacer(88)
      ])
   }
}

enum HistoryState {
   case loadProfilError
   case loadTransactionsError

   case present([TableItemsSection])
}

extension HistoryScene: SceneStateProtocol {
   func setState(_ state: HistoryState) {
      switch state {
      case .loadProfilError:
         break
      case .loadTransactionsError:
         break
      case .present(let sections):
         viewModels.tableModel
            .set(.backColor(.gray))
            .set(.itemSections(sections))
      }
   }
}
