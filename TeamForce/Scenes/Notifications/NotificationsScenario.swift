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
               guard let challInput = NotificationToChallengeDetailsSceneInput.convert($0) else { return }

               Asset.router?.route(.push, scene: \.challengeDetails, payload: challInput)
            //
            case .commentAdded:
               if let feed = NotificationToFeedElement.convert($0) {
                  Asset.router?.route(.push, scene: \.transactDetails, payload: feed)
               } else if let challInput = NotificationToChallengeDetailsSceneInput.convert($0) {
                  Asset.router?.route(.push, scene: \.challengeDetails, payload: challInput)
               }
            //
            case .likeAdded:
               guard let likeData = $0.likeData else { return }
               
               break
            //
            case .challengeWin:
               guard let challInput = NotificationToChallengeDetailsSceneInput.convert($0) else { return }

               Asset.router?.route(.push, scene: \.challengeDetails, payload: challInput)
            //
            case .finishedChallenge:
               guard let challInput = NotificationToChallengeDetailsSceneInput.convert($0) else { return }

               Asset.router?.route(.push, scene: \.challengeDetails, payload: challInput)
            }
         }
         .doMap {
            $0.id
         }
         .doNext(works.notificationReadWithId)
         .onSuccess {
            print("success")
         }
         .onFail {
            print("fail")
         }
   }
}
