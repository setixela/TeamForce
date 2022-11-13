//
//  NotificationsScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import ReactiveWorks

struct NotificationsEvents {
   let didSelectIndex: VoidWork<Int>
}

final class NotificationsScenario<Asset: AssetProtocol>:
   BaseScenario<NotificationsEvents, NotificationsState, NotificationsWorks<Asset>>, Assetable
{
   override func start() {
      works.getNotifications
         .doAsync()
         .onFail(setState, .loadNotifyError)
         .doNext(usecase: IsNotEmpty())
         .onFail(setState, .hereIsEmpty)
         .doNext(works.getNotifySections)
         .onSuccess(setState) { .presentNotifySections($0) }

      events.didSelectIndex
         .doNext(works.getNotificationByIndex)
         .onSuccess {
            switch $0.type {
            case .transactAdded:
               guard let feed = NotificationToTransaction.convert($0) else { return }

               Asset.router?.route(.push, scene: \.transactDetails, payload: feed)
            //
            case .challengeCreated:
               Asset.router?.route(.push, scene: \.challengeDetails, payload: nil)
            //
            case .commentAdded:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
               //
               break
            case .likeAdded:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
               //
               break
            case .challengeWin:
               Asset.router?.route(.push, scene: \.challengeDetails, payload: nil)
            //
            case .finishedChallenge:
               Asset.router?.route(.push, scene: \.challengeDetails, payload: nil)
               //
            }
         }
   }
}

// Transaction event
// Challenge created
// Comment added
// Some liked
// Comment added
// User finished challenge

protocol Converter {
   associatedtype In
   associatedtype Out

   static func convert(_ input: In) -> Out?
}

struct NotificationToTransaction: Converter {
   static func convert(_ input: Notification) -> Transaction? {
      let notify = input
      guard let transact = input.transactionData else { return nil }

      return Transaction(
         id: transact.transactionId,
         sender: nil,
         senderId: transact.senderId,
         recipient: nil,
         recipientId: transact.recipientId,
         transactionStatus: nil,
         transactionClass: nil,
         expireToCancel: nil,
         amount: transact.amount?.toString,
         createdAt: notify.createdAt,
         updatedAt: notify.updatedAt,
         reason: nil,
         graceTimeout: nil,
         isAnonymous: nil,
         isPublic: nil,
         photo: nil,
         organization: nil,
         period: nil,
         scope: nil
      )
   }
}

struct NotificationToFeedElement: Converter {
   static func convert(_ input: Notification) -> FeedElement? {
      let notify = input
      guard let transact = input.transactionData else { return nil }

      return FeedElement(
         id: transact.transactionId,
         time: notify.createdAt,
         eventTypeId: 0,
         eventObjectId: nil,
         eventRecordId: nil,
         objectSelector: nil,
         likesAmount: 0,
         commentsAmount: 0
      )
   }
}
