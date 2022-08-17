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
   var filterTransactions: Work<Int, [TableItemsSection]> { get }
}

final class HistoryWorks<Asset: AssetProtocol>: BaseSceneWorks<HistoryWorks.Temp, Asset>, HistoryWorksProtocol {
   private lazy var useCase = Asset.apiUseCase

   // Temp Storage
   final class Temp: InitProtocol {
      var currentUser: String?
      var transactions: [Transaction]?
      var sections: [TableItemsSection]?
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
   lazy var filterTransactions = Work<Int, [TableItemsSection]> { [weak self] work in

      guard var transactions = Self.store.transactions else {
         work.fail(())
         return
      }

      let selectedSegmentIndex = work.unsafeInput

      var result = [TableItemsSection]()
      var prevDay = ""

      switch selectedSegmentIndex {
      case 1:
         transactions = transactions.filter {
            $0.sender.senderTgName != Self.store.currentUser
         }
      case 2:
         transactions = transactions.filter {
            $0.sender.senderTgName == Self.store.currentUser
         }
      default:
         break
      }

      result = transactions
         .reduce([TableItemsSection]()) { result, transact in
            var state = TransactionItem.State.recieved
            if transact.sender.senderTgName == Self.store.currentUser {
               state = .sendSuccess
            }

            let item = TransactionItem(
               state: state,
               sender: transact.sender,
               recipient: transact.recipient,
               amount: transact.amount,
               createdAt: transact.createdAt
            )

            var result = result
            let currentDay = Self.convertToDate(time: item.createdAt) ?? ""

            if prevDay != currentDay {
               result.append(TableItemsSection(title: currentDay,
                                               items: []))
            }

            guard var currentSection = result.last else { return result }

            result = result.dropLast()
            currentSection.items.append(item)
            result.append(currentSection)

            return result
         }

      work.success(result: result)
      Self.store.sections = result
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
