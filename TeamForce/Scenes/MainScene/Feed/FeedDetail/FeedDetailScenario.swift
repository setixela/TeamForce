//
//  FeedDetailScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 28.09.2022.
//

import ReactiveWorks
import UIKit

import ReactiveWorks
import UIKit

struct FeedDetailEvents {
   let presentComment: VoidWork<Void>
   let presentReactions: VoidWork<Void>
   let reactionPressed: VoidWork<PressLikeRequest>
   let saveInput: VoidWork<Feed>
}

final class FeedDetailScenario<Asset: AssetProtocol>:
   BaseScenario<FeedDetailEvents, FeedDetailSceneState, FeedDetailWorks<Asset>>, Assetable
{
   override func start() {
      
      events.reactionPressed
         .doNext(work: works.pressLike)
         .onFail(setState) { .failedToReact }
         .doNext(work: works.getTransactStat)
         .onSuccess(setState) { .updateReactions($0) }
      
      events.saveInput
         .doNext(work: works.saveInput)
         .onSuccess {
            print("saved input")
         }
         .doNext(work: works.getComments)
         .onSuccess(setState) { .presentComments($0) }
      
   }
}
