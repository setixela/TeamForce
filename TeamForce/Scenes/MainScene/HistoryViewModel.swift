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

   // MARK: - View Models
   private lazy var tableModel = TableViewModel()
      .set(.borderColor(.gray))
      .set(.borderWidth(1))
      .set(.cornerRadius(Design.Parameters.cornerRadius))
    
   private lazy var segmentedControl = SegmentedControlModel()
        .set(.items(["Все", "Получено", "Отправлено"]))
        .set(.height(50))
        .set(.selectedSegmentIndex(0))
   // MARK: - Frame Cells
    
   // MARK: - Services

   private lazy var getTransactionsUseCase = Asset.apiUseCase.getTransactions.work()
   private lazy var loadProfileUseCase = Asset.apiUseCase.loadProfile.work()

   private lazy var currentUser: String = ""
   private lazy var transactions: [Transaction] = []

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
   }
    
    private func configureTableModel(cells: [Transaction], selectedSegmentIndex: Int) {
        var models: [LogoTitleSubtitleModel] = []
        
        var isSendingCoin: Bool = false
        for transaction in cells {
            isSendingCoin = false
            var rightText = "Перевод от " + transaction.sender
            var downText = transaction.amount
            var image = Design.icon.make(\.recieveCoinIcon)
            if transaction.sender == currentUser {
                isSendingCoin = true
                rightText = "Перевод для " + transaction.recipient
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
                selectedSegmentIndex == 0 {
                models.append(cell)
            }
            
        }
        print("segment \(selectedSegmentIndex), models count \(models.count), cells \(cells.count)")

        tableModel
           .set(.backColor(.gray))
           .set(.models(models))
    }
}

extension UIEdgeInsets {
   static func outline(_ width: CGFloat) -> UIEdgeInsets {
      .init(top: width, left: width, bottom: width, right: width)
   }
}
