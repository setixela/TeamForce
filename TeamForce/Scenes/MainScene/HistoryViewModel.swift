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

   private var sections: [TableSection] = []

   // MARK: - View Models

   private lazy var tableModel = TableViewModel()
      .set(.borderColor(.gray))
      .set(.borderWidth(1))
      .set(.cornerRadius(Design.Parameters.cornerRadius))

   private lazy var segmentedControl = SegmentedControlModel()
      .set(.items(["Все", "Получено", "Отправлено"]))
      .set(.height(50))
      .set(.selectedSegmentIndex(0))

   // MARK: - Services

   struct TempStore: KeyPathSetable {
      var currentUser: String = ""
      var transactions: [Transaction] = []
      var sections: [[Transaction]] = []
   }

   private var store = TempStore()

   private lazy var getTransactionsUseCase = Asset.apiUseCase.getTransactions.work()
   private lazy var loadProfileUseCase = Asset.apiUseCase.loadProfile.work()
   private lazy var getTransactionByIdUse = Asset.apiUseCase.getTransactionById.work()
   private lazy var safeStringStorage = StringStorageWorker(engine: Asset.service.safeStringStorage)

   private lazy var currentUser: String = ""
   private lazy var transactions: [Transaction] = []
   private lazy var tokens: (token: String, csrf: String) = ("", "")

   override func start() {
      weak var wS = self
      set(.axis(.vertical))
      set(.models([
         segmentedControl,
         Spacer(10),
         tableModel
      ]))

      loadProfileUseCase
         .doAsync()
         .onSuccess { user in
            wS?.currentUser = user.profile.tgName
         }
         .onFail {
            print("profile not loaded")
         }

      getTransactionsUseCase
         .doAsync()
         .onSuccess { transactions in
            wS?.transactions = transactions
            guard let index = wS?.segmentedControl.getSelectedIndex() else { return }
            wS?.configureTableModel(cells: transactions, selectedSegmentIndex: index)
         }
         .onFail {
            print("transactions not loaded")
         }


      segmentedControl
         .onEvent(\.segmentChanged) { index in
            print("selected index \(index)")
            guard let transactions = wS?.transactions else { return }
            wS?.configureTableModel(cells: transactions, selectedSegmentIndex: index)
         }
       
       safeStringStorage
          .doAsync("token")
          .onSuccess {
             wS?.tokens.token = $0
          }
          .onFail {
             print("token load failed")
          }
          .doInput("csrftoken")
          .doNext(worker: safeStringStorage)
          .onSuccess {
             wS?.tokens.csrf = $0
          }
          .onFail {
             print("csrftoken load failed")
          }
       
       tableModel.onEvent(\.didSelectRow) { indexPath in
           print("indexPath is \(indexPath)")
           let id = self.store.sections[indexPath.section][indexPath.row]
           print("id \(id.id)")
           let request = TransactionRequest(token: self.tokens.token,
                                            csrfToken: self.tokens.csrf,
                                            id: id.id)
           self.getTransactionByIdUse
               .doAsync(request)
               .onSuccess { transaction in
                   print(transaction)
                   print("success happend")
                   ProductionAsset.router?.route(\.transactionDetail, navType: .push, payload: transaction)
               }
               .onFail {
                   print("failed")
               }
       }
   }

   private func configureTableModel(cells: [Transaction], selectedSegmentIndex: Int) {
      var models: [UIViewModel] = []
      var modelsWithTransactions: [Transaction] = []
      var sections: [TableSection] = []
      var sectionWithTransactions: [[Transaction]] = []
      var isSendingCoin = false
      var prevDay = ""

      for transaction in cells {
         guard let currentDay = convertToDate(time: transaction.createdAt) else { return }
         if prevDay != currentDay {
            if models.count > 0 {
               sections.append(TableSection(title: prevDay,
                                            models: models))
               sectionWithTransactions.append(modelsWithTransactions)
               models = []
               modelsWithTransactions = []
            }
         }

         isSendingCoin = false
          var rightText = "Перевод от " + transaction.sender.senderTgName
         var downText = transaction.amount
         var image = Design.icon.make(\.recieveCoinIcon)
          if transaction.sender.senderTgName == currentUser {
            isSendingCoin = true
              rightText = "Перевод для " + transaction.recipient.recipientTgName
            downText = "+" + transaction.amount
            image = Design.icon.make(\.sendCoinIcon)
         }

         let cell = LogoTitleSubtitleModel(isAutoreleaseView: true)
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
            modelsWithTransactions.append(transaction)
         }

         prevDay = currentDay
      }
      if !models.isEmpty {
         sections.append(TableSection(title: prevDay,
                                      models: models))
         sectionWithTransactions.append(modelsWithTransactions)
         models = []
         modelsWithTransactions = []
      }
       
      self.store.sections = sectionWithTransactions
      tableModel
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

extension UIEdgeInsets {
   static func outline(_ width: CGFloat) -> UIEdgeInsets {
      .init(top: width, left: width, bottom: width, right: width)
   }
}
