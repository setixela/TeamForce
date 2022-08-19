//
//  MemoryLeakTests.swift
//  TeamForceTests
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import XCTest
@testable import TeamForce
@testable import ReactiveWorks

class HistoryMemoryLeakTests: XCTestCase {
   private var viewModels = HistoryViewModels<ProductionAsset.Design>()


   func testWorksMemoryLeaks() throws {
      var works: HistoryWorks<ProductionAsset>? = HistoryWorks<ProductionAsset>()

      weak var weakWorks = works
      works = nil

      XCTAssertNil(weakWorks)
   }

   func testScenarioMemoryLeaks() throws {
      let works: HistoryWorks<ProductionAsset> = HistoryWorks<ProductionAsset>()
      var scenario: HistoryScenario? = HistoryScenario(
         works: works,
         events: HistoryScenarioEvents(
            segmentContorlEvent: viewModels.segmentedControl.onEvent(\.segmentChanged)
         )
      )

      weak var weakScenario = scenario
      scenario = nil

      XCTAssertNil(weakScenario)
   }
}

class TransactMemoryLeakTests: XCTestCase {
   private var viewModels = TransactViewModels<ProductionAsset>()


   func testWorksMemoryLeaks() throws {
      var works: TransactWorks<ProductionAsset>? = TransactWorks<ProductionAsset>()

      weak var weakWorks = works
      works = nil

      XCTAssertNil(weakWorks)
   }

   func testScenarioMemoryLeaks() throws {
      var scenario: TransactScenario? = TransactScenario(
         works: TransactWorks<ProductionAsset>(),
         events: TransactScenarioEvents(
            userSearchTFBeginEditing: viewModels.userSearchTextField.onEvent(\.didBeginEditing),
            userSearchTFDidEditingChanged: viewModels.userSearchTextField.onEvent(\.didEditingChanged),
            userSelected: viewModels.tableModel.onEvent(\.didSelectRow),
            sendButtonEvent: viewModels.sendButton.onEvent(\.didTap),
            transactInputChanged: viewModels.transactInputViewModel.textField.onEvent(\.didEditingChanged),
            reasonInputChanged: viewModels.reasonTextView.onEvent(\.didEditingChanged)
         )
      )

      weak var weakScenario = scenario
      scenario = nil

      XCTAssertNil(weakScenario)
   }
}

