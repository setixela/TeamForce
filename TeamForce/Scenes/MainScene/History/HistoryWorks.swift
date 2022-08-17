//
//  HistoryWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import Foundation
import ReactiveWorks
import RealmSwift
import SwiftUI

protocol HistoryWorksProtocol {
   var loadProfile: Work<Void, Void> { get }
   var getTransactions: Work<Void, [Transaction]> { get }
   var getTransactionById: Work<Int, Transaction> { get }

   // TODO: - Потом разобрать и перенести, никаких тут вью моделей, Саша!
   var filterTransactions: Work<Int, [TableSection]> { get }
}

final class HistoryWorks<Asset: AssetProtocol>: BaseSceneWorks<HistoryWorks.Temp, Asset>, HistoryWorksProtocol {
   private lazy var useCase = Asset.apiUseCase

   // Temp Storage
   final class Temp: InitProtocol {
      var currentUser: String?
      var transactions: [Transaction]?
      var sections: [TableSection]?
      var currentTransaction: Transaction?
   }

   // MARK: - Works

   lazy var getTransactions = Work<Void, [Transaction]>() { [weak self] work in
      self?.useCase.getTransactions.work
         .retainBy(self?.retainer)
         .doAsync()
         .onSuccess {
            Self.store.transactions = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail(())
         }
   }

   lazy var getTransactionById = Work<Int, Transaction>() { [weak self] work in
      self?.useCase.getTransactionById.work
         .retainBy(self?.retainer)
         .doAsync()
         .onSuccess {
            Self.store.currentTransaction = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail(())
         }
   }

   lazy var loadProfile = Work<Void, Void>() { [weak self] work in
      self?.useCase.loadProfile.work
         .retainBy(self?.retainer)
         .doAsync()
         .onSuccess {
            Self.store.currentUser = $0.profile.tgName
            work.success(result: ())
         }
         .onFail {
            work.fail(())
         }
   }

   // Fucking shit)))
   lazy var filterTransactions = Work<Int, [TableSection]> { [weak self] work in

      guard let transactions = Self.store.transactions else {
         work.fail(())
         return
      }

      let selectedSegmentIndex = work.unsafeInput

      var models: [UIViewModel] = []
      var sections: [TableSection] = []

      var isSendingCoin = false
      var prevDay = ""

      for transaction in transactions {
         guard let currentDay = Self.convertToDate(time: transaction.createdAt) else { return }
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
         if transaction.sender.senderTgName == Self.store.currentUser {
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
      Self.store.sections = sections

      work.success(result: sections)
   }

   private static func convertToDate(time: String) -> String? {

      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      guard let convertedDate = inputFormatter.date(from: time) else { return nil }

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "d MMM y"

      return outputFormatter.string(from: convertedDate)
   }
}
