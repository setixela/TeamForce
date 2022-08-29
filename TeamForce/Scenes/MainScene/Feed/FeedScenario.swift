//
//  FeedScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks

struct FeedScenarioInputEvents {
   let loadFeedForCurrentUser: VoidWork<UserData?>

   let presentAllFeed: VoidWork<Void>
   let presentMyFeed: VoidWork<Void>
   let presentPublicFeed: VoidWork<Void>
}

final class FeedScenario<Asset: AssetProtocol>:
   BaseScenario<FeedScenarioInputEvents, FeedSceneState, FeedWorks<Asset>>, Assetable
{
   private var userName: String = ""

   override func start() {
      events.loadFeedForCurrentUser
         .doNext(work: works.loadFeedForCurrentUser)
         .doNext(work: works.getAllFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)

      events.presentAllFeed
         .doNext(work: works.getAllFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)

      events.presentMyFeed
         .doNext(work: works.getMyFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)

      events.presentPublicFeed
         .doNext(work: works.getPublicFeed)
         .onSuccess(setState) { .presentFeed($0) }
         .onFail(setState, .loadFeedError)
   }
}
