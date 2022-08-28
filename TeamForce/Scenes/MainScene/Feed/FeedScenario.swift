//
//  FeedScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks

struct FeedScenarioInputEvents {
   let loadFeedForCurrentUser: VoidWork<UserData?>
}

final class FeedScenario<Asset: AssetProtocol>:
   BaseScenario<FeedScenarioInputEvents, FeedSceneState, FeedWorks<Asset>>, Assetable
{
   override func start() {
      events.loadFeedForCurrentUser
         .doNext(work: works.loadFeedForCurrentUser)
         .onSuccess(setState) { .presentAllFeed($0) }
         .onFail(setState, .loadFeedError)
   }
}
