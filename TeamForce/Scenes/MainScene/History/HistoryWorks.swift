//
//  HistoryWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import Foundation
import ReactiveWorks

protocol HistoryWorksProtocol {
   var loadProfile: Work<Void, Void> { get }
   var getTransactions: Work<Void, [Transaction]> { get }
   var getTransactionById: Work<Int, Transaction> { get }

   var getAllTransactItems: Work<Void, [TableItemsSection]> { get }
   var getSentTransactItems: Work<Void, [TableItemsSection]> { get }
   var getRecievedTransactItems: Work<Void, [TableItemsSection]> { get }
}

final class HistoryWorks<Asset: AssetProtocol>: BaseSceneWorks<HistoryWorks.Temp, Asset>, HistoryWorksProtocol {
   private lazy var useCase = Asset.apiUseCase

   // Temp Storage
   final class Temp: InitProtocol {
      var currentUser: String?
      var transactions: [Transaction]?
      var sections: [TableItemsSection]?
      var currentTransaction: Transaction?
      var segmentId: Int?
      
      var sentTransactions: [Transaction]?
      var recievedTransactions: [Transaction]?
   }

   // MARK: - Works

   var getTransactions: Work<Void, [Transaction]> {
      
      .init { [weak self] work in
         let request = HistoryRequest()
         self?.useCase.getTransactions
            .doAsync(request)
            .onSuccess {
               Self.store.transactions = $0
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
      .retainBy(retainer)
   }
   
   var getSentTransactions: Work<Void, [Transaction]> {
      .init { [weak self] work in
         let request = HistoryRequest(sentOnly: true)
         self?.useCase.getTransactions
            .doAsync(request)
            .onSuccess {
               Self.store.sentTransactions = $0
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
      .retainBy(retainer)
   }
   
   var getRecievedTransactions: Work<Void, [Transaction]> {
      .init { [weak self] work in
         let request = HistoryRequest(receivedOnly: true)
         self?.useCase.getTransactions
            .doAsync(request)
            .onSuccess {
               Self.store.recievedTransactions = $0
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
      .retainBy(retainer)
   }

   var getTransactionById: Work<Int, Transaction> {
      .init { [weak self] work in
         self?.useCase.getTransactionById
            .doAsync()
            .onSuccess {
               Self.store.currentTransaction = $0
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
      .retainBy(retainer)
   }
   //
   var getProfileById: Work<Int, UserData> {
      .init { [weak self] work in
         self?.useCase.getProfileById
            .doAsync(work.input)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
      .retainBy(retainer)
   }

   var getTransactionByRowNumber: Work<(IndexPath, Int), Transaction> {
      .init { work in

         let segmentId = Self.store.segmentId
         var filtered: [Transaction] = []
         if segmentId == 0 { filtered = Self.store.transactions ?? [] }
         else if segmentId == 1 { filtered = Self.store.recievedTransactions ?? [] }
         else if segmentId == 2 { filtered = Self.store.sentTransactions ?? [] }

         if let index = work.input?.1 {
            let transaction = filtered[index]
            work.success(result: transaction)
         } else {
            work.fail()
         }
      }
      .retainBy(retainer)
   }

   var loadProfile: Work<Void, Void> {
      .init { [weak self] work in
         self?.useCase.loadProfile
            .doAsync()
            .onSuccess {
               Self.store.currentUser = $0.profile.tgName
               work.success()
            }
            .onFail {
               work.fail()
            }
      }
      .retainBy(retainer)
   }

   var getAllTransactItems: Work<Void, [TableItemsSection]> {
      .init {
         guard let filtered = Self.store.transactions else { $0.fail(); return }
         let items = Self.convertToItems(filtered)
         Self.store.segmentId = 0

         $0.success(result: items)
      }
      .retainBy(retainer)
   }

   var getSentTransactItems: Work<Void, [TableItemsSection]> {
      .init {
         guard let filtered = Self.store.sentTransactions else { $0.fail(); return }
         let items = Self.convertToItems(filtered)
         Self.store.segmentId = 2

         $0.success(result: items)
      }
      .retainBy(retainer)
   }

   var getRecievedTransactItems: Work<Void, [TableItemsSection]> {
      .init {
         guard let filtered = Self.store.recievedTransactions else { $0.fail(); return }
         let items = Self.convertToItems(filtered)
         Self.store.segmentId = 1

         $0.success(result: items)
      }
      .retainBy(retainer)
   }
   
   var cancelTransactionById: Work<Int, Void> {
      .init { [weak self] work in
         self?.useCase.cancelTransactionById
            .doAsync(work.input)
            .onSuccess {
               print("cancelled transaction successfully")
               work.success()
            }
            .onFail {
               work.fail()
            }
         
      }.retainBy(retainer)
   }
}

private extension HistoryWorks {

   static func convertToItems(_ filtered: [Transaction]) -> [TableItemsSection] {
      guard !filtered.isEmpty else { return [] }

      var prevDay = ""

      return filtered
         .reduce([TableItemsSection]()) { result, transact in
            var state = TransactionItem.State.waiting
            let transactionStatus = transact.transactionStatus?.id
            switch transactionStatus {
            case "W":
               state = TransactionItem.State.waiting
            case "A":
               state = TransactionItem.State.approved
            case "D":
               state = TransactionItem.State.declined
            case "I":
               state = TransactionItem.State.ingrace
            case "R":
               state = TransactionItem.State.ready
            case "C":
               state = TransactionItem.State.cancelled
            default:
               state = TransactionItem.State.waiting
            }

            var authorPhoto = transact.recipient?.recipientPhoto

            if transact.sender?.senderTgName != Self.store.currentUser {
               state = .recieved
               authorPhoto = transact.sender?.senderPhoto
            }

            let item = TransactionItem(
               state: state,
               sender: transact.sender ?? Sender(senderId: nil,
                                                 senderTgName: nil,
                                                 senderFirstName: nil,
                                                 senderSurname: nil,
                                                 senderPhoto: nil),
               recipient: transact.recipient ?? Recipient(recipientId: nil,
                                                          recipientTgName: nil,
                                                          recipientFirstName: nil,
                                                          recipientSurname: nil,
                                                          recipientPhoto: nil),
               amount: transact.amount.string,
               createdAt: transact.createdAt.string,
               photo: authorPhoto,
               isAnonymous: transact.isAnonymous ?? false,
               id: transact.id
            )

            var result = result
            
            var currentDay = item.createdAt.dateConverted
            if let date = item.createdAt.dateConvertedToDate {
               if Calendar.current.isDateInToday(date) {
                  currentDay = Design.Text.title.today
               } else if Calendar.current.isDateInYesterday(date) {
                  currentDay = Design.Text.title.yesterday
               }
            }

            if prevDay != currentDay {
               result.append(TableItemsSection(title: currentDay))
            }

            result.last?.items.append(item)
            prevDay = currentDay
            return result
         }
   }
}
