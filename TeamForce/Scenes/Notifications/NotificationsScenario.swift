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
               guard let feed = NotificationToFeedElement.convert($0) else { return }

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
