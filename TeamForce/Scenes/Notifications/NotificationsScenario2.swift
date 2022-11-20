//
//  NotificationsScenario2.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.11.2022.
//

import ReactiveWorks

struct NotificationsDetailsEvents {
   let didSelectIndex: WorkVoid<Int>
}

final class NotificationsDetailsScenario<Asset: AssetProtocol>:
   BaseScenario<NotificationsDetailsEvents, DetailsPresenterState, NotificationsWorks<Asset>>, Assetable
{
   override func start() {
      events.didSelectIndex
         .doNext(works.getNotificationByIndex)
         .onSuccess(setState) {
            switch $0.type {
            case .transactAdded:
               guard let feed = NotificationToFeedElement.convert($0) else {
                  return .presentNothing
               }

               return .presentDetails(.transaction(.feedElement(feed)))
            case .challengeCreated:
               guard let challData = NotificationToChallengeDetailsData.convert($0) else {
                  return .presentNothing
               }

               return .presentDetails(.challenge(.byChallenge(challData)))
            case .commentAdded:
               guard let commentData = $0.commentData else {
                  return .presentNothing
               }

               if let id = commentData.transactionId {
                  return  .presentDetails(.transaction(.transactId(id)))
               } else if let id = commentData.challengeId {
                  return .presentDetails(.challenge(.byId(id)))
               }
            case .likeAdded:
               guard let likeData = $0.likeData else {
                  return .presentNothing
               }

               if let id = likeData.transactionId {
                  return .presentDetails(.transaction(.transactId(id)))
               } else if let id = likeData.challengeId {
                  return  .presentDetails(.challenge(.byId(id)))
               } else if let _ = likeData.commentId {
                  if let id = likeData.transactionId {
                     return .presentDetails(.transaction(.transactId(id)))
                  } else if let id = likeData.challengeId {
                     return .presentDetails(.challenge(.byId(id)))
                  }
               }
               //
            case .challengeWin:
               guard let chall = NotificationToChallengeDetailsData.convert($0) else {
                  return .presentNothing
               }

               return .presentDetails(.challenge(.byChallenge(chall)))
               //
            case .finishedChallenge:
               guard let chall = NotificationToChallengeDetailsData.convert($0) else {
                  return .presentNothing
               }

               return .presentDetails(.challenge(.byChallenge(chall)))
            }

            return .presentNothing
         }
   }
}
