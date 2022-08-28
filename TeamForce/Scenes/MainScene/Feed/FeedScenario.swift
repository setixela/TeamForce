//
//  FeedScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks

struct FeedScenarioInputEvents {
   let loadFeed: VoidWork<Void>
}

final class FeedScenario<Asset: AssetProtocol>:
   BaseScenario<FeedScenarioInputEvents, FeedSceneState, FeedWorks<Asset>>, Assetable
{
   override func start() {
      events.loadFeed
         .doNext(work: works.getFeed)
         .onSuccess(setState) {
            .presentAllFeed($0)

         }
         .onFail(setState, .loadFeedError)
   }
}
