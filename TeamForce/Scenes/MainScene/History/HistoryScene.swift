//
//  HistoryScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import ReactiveWorks
import UIKit

// MARK: - HistoryScene

final class HistoryScene<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Assetable,
   Stateable,
   Scenaryable
{
   //
   typealias State = StackState

   private lazy var viewModels = HistoryViewModels<Design>()

   lazy var scenario = HistoryScenario(
      works: HistoryWorks<Asset>(),
      events: HistoryScenarioEvents(segmentContorlEvent: viewModels.segmentedControl.onEvent(\.segmentChanged)))

   // MARK: - Start

   override func start() {
      configure()
      scenario.start()
   }
}

// MARK: - Configure presenting

private extension HistoryScene {
   func configure() {
      set_models([
         viewModels.segmentedControl,
         viewModels.tableModel,
         Grid.xxx.spacer
      ])
   }
}

enum HistoryState {
   case loadProfilError
   case loadTransactionsError

   case present([TableSection])
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
            .set(.sections(sections))
      }
   }
}
