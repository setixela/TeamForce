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
   let presentDetails: VoidWork<Void>
   let presentComment: VoidWork<Void>
   let presentReactions: VoidWork<Void>
   let reactionPressed: VoidWork<PressLikeRequest>
   let saveInput: VoidWork<(Feed, String)>
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
         .onSuccess(setState) { .presentDetails($0) }

      events.presentDetails
         .doNext(works.getFeed)
         .onSuccess(setState) { .presentDetails($0) }

      events.presentComment
         .doNext(works.getComments)
         .onSuccess(setState) { .presentComments($0) }

      events.presentDetails
   }
}
