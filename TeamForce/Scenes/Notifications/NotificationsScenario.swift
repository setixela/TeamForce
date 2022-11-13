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
   BaseScenario<NotificationsEvents, NotificationsState, NotificationsWorks<Asset>>, Assetable {
   
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
            Asset.router?.route(.pop)
            switch $0.type {
            case .transactAdded: 
               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
            case .challengeCreated:
               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
            case .commentAdded:
               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
            case .likeAdded:
               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
            case .challengeWin:
               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
            case .finishedChallenge:
               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
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
