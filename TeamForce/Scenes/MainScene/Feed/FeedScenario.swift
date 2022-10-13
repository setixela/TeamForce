//
//  FeedScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks
import UIKit

struct FeedScenarioInputEvents {
   let loadFeedForCurrentUser: VoidWork<UserData?>

   let presentAllFeed: VoidWork<Void>
   let presentMyFeed: VoidWork<Void>
   let presentPublicFeed: VoidWork<Void>
   let presentProfile: VoidWork<Int>
   let reactionPressed: VoidWork<PressLikeRequest>
   let presentDetail: VoidWork<(IndexPath, Int)>
}

final class FeedScenario<Asset: AssetProtocol>:
   BaseScenario<FeedScenarioInputEvents, FeedSceneState, FeedWorks<Asset>>, Assetable
{
   private var userName: String = ""

   override func start() {
      
      events.loadFeedForCurrentUser
         .doNext(works.loadFeedForCurrentUser)
         .onFail(setState, .loadFeedError)
         .doNext(works.getAllFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)

      events.presentAllFeed
         .doNext(works.getAllFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)

      events.presentMyFeed
         .doNext(works.getMyFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)

      events.presentPublicFeed
         .doNext(works.getPublicFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)
      
      events.presentProfile
         .onSuccess(setState) { .presentProfile($0) }
      
      events.reactionPressed
         .doNext(works.pressLike)
         .onFail {
            print("failed to like")
         }
         .doMap() {
            self.events.loadFeedForCurrentUser.result
         }
         .doNext(works.loadFeedForCurrentUser)
         .onFail(setState, .loadFeedError)
         .doNext(works.getAllFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)
      
      events.presentDetail
         .doNext(works.getFeedByRowNumber)
         .onSuccess(setState) {
            .presentDetailView($0)}
         .onFail {
            print("fail ")
         }
      
         
   }
}
