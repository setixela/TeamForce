//
//  HistoryScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryViewModels<Design: DesignProtocol> {
   let tableModel: TableViewModel
   let segmentedControl: SegmentedControlModel
}

struct HistorySceneryCase: SceneModeProtocol {
   var inputUserName: VoidEvent?
   var inputSmsCode: VoidEvent?
}

final class HistoryScenario<Asset: AssetProtocol>:
   BaseScenario<HistoryViewModels<Asset.Design>, HistoryWorks<Asset>>
{
   var modes: HistorySceneryCase = .init()

   override func start() {
      configure()

      let works = works
      let vModels = vModels

      works.loadProfile.doAsync()

      works.getTransactions
         .doAsync()
         .onSuccess {
            guard
               let transactions = works.store.transactions
            else { return }
            let index = vModels.segmentedControl.getSelectedIndex()
            self.configureTableModel(cells: transactions, selectedSegmentIndex: index)
         }
         .onFail {
            print("Transactions not loaded")
         }

      vModels.segmentedControl
         .onEvent(\.segmentChanged) { index in
            guard let transactions = works.store.transactions else { return }
            self.configureTableModel(cells: transactions, selectedSegmentIndex: index)
         }

   }
}

// MARK: - Configure scene states

extension HistoryScenario: SceneModable {
   private func configure() {
//      let vModels = vModels
//
//      onModeChanged(\.inputUserName) {
////         vModels.smsCodeInputModel.set_hidden(true)
////         vModels.userNameInputModel.set_hidden(false)
////         vModels.loginButton.set_hidden(true)
////         vModels.getCodeButton.set_hidden(false)
//      }
//      onModeChanged(\.inputSmsCode) {
////         vModels.smsCodeInputModel.set_hidden(false)
////         vModels.loginButton.set_hidden(false)
////         vModels.getCodeButton.set_hidden(true)
//      }
//      setMode(\.inputUserName)
   }
}

extension HistoryScenario {
   private func configureTableModel(cells: [Transaction], selectedSegmentIndex: Int) {
      var models: [UIViewModel] = []
      var sections: [TableSection] = []

      var isSendingCoin = false
      var prevDay = ""

      for transaction in cells {
         guard let currentDay = convertToDate(time: transaction.createdAt) else { return }
         if prevDay != currentDay {
            if models.count > 0 {
               sections.append(TableSection(title: prevDay,
                                            models: models))
               models = []
            }
         }

         isSendingCoin = false
         var rightText = "Перевод от " + transaction.sender.senderTgName
         var downText = transaction.amount
         var image = Asset.Design.icon.recieveCoinIcon
         if transaction.sender.senderTgName == works.store.currentUser {
            isSendingCoin = true
            rightText = "Перевод для " + transaction.recipient.recipientTgName
            downText = "+" + transaction.amount
            image = Asset.Design.icon.sendCoinIcon
         }

         let cell = IconTitleSubtitleModel(isAutoreleaseView: true)
            .set(.image(image))
            .set(.padding(.outline(10)))
            .set(.size(.init(width: 64, height: 64)))
            .setRight {
               $0
                  .set(.text(rightText))
                  .setDown {
                     $0.set(.text(downText))
                  }
            }  
         if (selectedSegmentIndex == 1 && !isSendingCoin) ||
            (selectedSegmentIndex == 2 && isSendingCoin) ||
            selectedSegmentIndex == 0
         {
            models.append(cell)
         }

         prevDay = currentDay
      }
      if !models.isEmpty {
         sections.append(TableSection(title: prevDay,
                                      models: models))
         models = []
      }
      works.store.sections = sections
      vModels.tableModel
         .set(.backColor(.gray))
         .set(.sections(sections))
   }

   private func convertToDate(time: String) -> String? {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      guard let convertedDate = inputFormatter.date(from: time) else { return nil }

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "d MMM y"

      return outputFormatter.string(from: convertedDate)
   }
}

