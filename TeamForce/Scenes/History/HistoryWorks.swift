//
//  HistoryWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 16.08.2022.
//

import Foundation
import ReactiveWorks

protocol HistoryWorksProtocol {
 //  var loadProfile: Work<Void, Void> { get }
   var getTransactions: Work<Bool, Void> { get }
   var getTransactionById: Work<Int, Transaction> { get }

   var getAllTransactItems: Work<Void, [TableItemsSection]> { get }
   var getSentTransactItems: Work<Void, [TableItemsSection]> { get }
   var getRecievedTransactItems: Work<Void, [TableItemsSection]> { get }
}

final class HistoryWorks<Asset: AssetProtocol>: BaseSceneWorks<HistoryWorks.Temp, Asset>, HistoryWorksProtocol {
   private lazy var useCase = Asset.apiUseCase

   // Temp Storage
   final class Temp: InitProtocol {
      var userData: UserData?
      //
      var currentUser: String?
      var transactions: [Transaction] = []
      var sections: [TableItemsSection]?
      var currentTransaction: Transaction?
      var segmentId: Int = 0

      var sentTransactions: [Transaction] = []
      var recievedTransactions: [Transaction] = []

      var allOffset = 1
      var sentOffset = 1
      var recievedOffset = 1

      var isAllPaginating = false
      var isSentPaginating = false
      var isRecievedPaginating = false

      var limit = 20
   }

   // MARK: - Works

   var pagination: Work<Bool, [TableItemsSection]> { .init { [weak self] work in
      switch Self.store.segmentId {
      case 0:
         self?.getTransactions
            .doAsync(true)
            .onSuccess {
               self?.getAllTransactItems
                  .doAsync()
                  .onSuccess {
                     work.success($0)
                  }
                  .onFail {
                     work.fail()
                  }
            }
            .onFail { work.fail() }
      case 1:
         self?.getRecievedTransactions
            .doAsync(true)
            .onSuccess {
               self?.getRecievedTransactItems
                  .doAsync()
                  .onSuccess {
                     work.success($0)
                  }
                  .onFail {
                     work.fail()
                  }
            }
            .onFail { work.fail() }
      case 2:
         self?.getSentTransactions
            .doAsync(true)
            .onSuccess {
               self?.getSentTransactItems
                  .doAsync()
                  .onSuccess {
                     work.success($0)
                  }
                  .onFail {
                     work.fail()
                  }
            }
            .onFail { work.fail() }
      default:
         work.fail()
      }
   }.retainBy(retainer) }
   
   var getTransactions: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { work.fail(); return }

      if Self.store.isAllPaginating { work.fail(); return }
      if paginating {
         Self.store.isAllPaginating = true
         Self.store.allOffset += 1
      }
      let pagination = Pagination(
         offset: Self.store.allOffset,
         limit: Self.store.limit
      )

      let request = HistoryRequest(pagination: pagination)
      self?.useCase.getTransactions
         .doAsync(request)
         .onSuccess {
            switch paginating {
            case true:
               Self.store.isAllPaginating = false
               Self.store.transactions.append(contentsOf: $0)
            case false:
               Self.store.transactions = $0
            }
            work.success()
         }
         .onFail {
            work.fail()
         }
   }
   .retainBy(retainer)
   }

   var getRecievedTransactions: Work<Bool, Void> { .init { [weak self] work in

      guard let paginating = work.input else { work.fail(); return }

      if Self.store.isRecievedPaginating { work.fail(); return }
      if paginating {
         Self.store.isRecievedPaginating = true
         Self.store.recievedOffset += 1
      }
      let pagination = Pagination(
         offset: Self.store.recievedOffset,
         limit: Self.store.limit
      )

      let request = HistoryRequest(
         pagination: pagination,
         receivedOnly: true
      )

      self?.useCase.getTransactions
         .doAsync(request)
         .onSuccess {
            switch paginating {
            case true:
               Self.store.isRecievedPaginating = false
               Self.store.recievedTransactions.append(contentsOf: $0)
            case false:
               Self.store.recievedTransactions = $0
            }
            work.success()
         }
         .onFail {
            work.fail()
         }
   }
   .retainBy(retainer)
   }

   var getSentTransactions: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { work.fail(); return }

      if Self.store.isSentPaginating { work.fail(); return }
      if paginating {
         Self.store.isSentPaginating = true
         Self.store.sentOffset += 1
      }
      let pagination = Pagination(
         offset: Self.store.sentOffset,
         limit: Self.store.limit
      )

      let request = HistoryRequest(
         pagination: pagination,
         sentOnly: true
      )
      self?.useCase.getTransactions
         .doAsync(request)
         .onSuccess {
            switch paginating {
            case true:
               Self.store.isSentPaginating = false
               Self.store.sentTransactions.append(contentsOf: $0)
            case false:
               Self.store.sentTransactions = $0
            }
            work.success()
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
         if segmentId == 0 { filtered = Self.store.transactions }
         else if segmentId == 1 { filtered = Self.store.recievedTransactions }
         else if segmentId == 2 { filtered = Self.store.sentTransactions }

         if let index = work.input?.1 {
            let transaction = filtered[index]
            work.success(result: transaction)
         } else {
            work.fail()
         }
      }
      .retainBy(retainer)
   }

   var initStorage: Work<UserData?, Void> {
      .init { [weak self] work in
         guard
            let userData = work.unsafeInput ?? Self.store.userData
         else {
            work.fail()
            return
         }

         Self.store.userData = userData

         Self.store.allOffset = 1
         Self.store.sentOffset = 1
         Self.store.recievedOffset = 1
         Self.store.transactions = []
         Self.store.sentTransactions = []
         Self.store.recievedTransactions = []
         
         self?.getTransactions
            .doAsync(false)
            .onSuccess { work.success() }
            .onFail { work.fail() }
         self?.getSentTransactions
            .doAsync(false)
            .onFail { work.fail() }
         self?.getRecievedTransactions
            .doAsync(false)
            .onFail { work.fail() }
      }
   }

   var getAllTransactItems: Work<Void, [TableItemsSection]> {
      .init {
         let filtered = Self.store.transactions
         let items = Self.convertToItems(filtered)
         Self.store.segmentId = 0

         $0.success(result: items)
      }
      .retainBy(retainer)
   }

   var getSentTransactItems: Work<Void, [TableItemsSection]> {
      .init {
         let filtered = Self.store.sentTransactions
         let items = Self.convertToItems(filtered)
         Self.store.segmentId = 2

         $0.success(result: items)
      }
      .retainBy(retainer)
   }

   var getRecievedTransactItems: Work<Void, [TableItemsSection]> {
      .init {
         let filtered = Self.store.recievedTransactions
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
   
   var getSegmentId: Work<Void, Int> { .init { work in
      work.success(Self.store.segmentId)
   }.retainBy(retainer) }

   var getTransactionsBySegment: Work<Int, [TableItemsSection]> { .init { [weak self] work in
      guard let id = work.input else { work.fail(); return }
      switch id {
      case 0:
         self?.getAllTransactItems
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
      case 1:
         self?.getRecievedTransactItems
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
      case 2:
         self?.getSentTransactItems
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
    
      default:
         work.fail()
      }
   }.retainBy(retainer) }
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
