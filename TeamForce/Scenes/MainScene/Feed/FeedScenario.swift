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

   let filterTapped: VoidWork<Button4Event>
   // let presentAllFeed: VoidWork<Void>
   // let presentTransactions: VoidWork<Void>
//   let presentPublicFeed: VoidWork<Void>
   let presentProfile: VoidWork<Int>
   let reactionPressed: VoidWork<PressLikeRequest>
   let presentDetail: VoidWork<Int>

   let pagination: VoidWork<Bool>
}

final class FeedScenario<Asset: AssetProtocol>:
   BaseScenario<FeedScenarioInputEvents, FeedSceneState, FeedWorks<Asset>>, Assetable
{
   private var userName: String = ""

   override func start() {
      works.retainer.cleanAll()

      events.loadFeedForCurrentUser
         .doNext(works.loadFeedForCurrentUser)
         .onFail(setState, .loadFeedError)
         .doNext(works.getSegmentId)
         .doNext(works.getFeedBySegment)
         //.doNext(works.getAllFeed)
         .onSuccess(setState) {
            .presentFeed($0)
         }
         .onFail(setState, .loadFeedError)

      events.filterTapped
         .doNext(works.filterWork)
         .onSuccess(setState) {
            .presentFeed($0)
         }
         .onFail(setState) {
            .loadFeedError
         }

      events.presentProfile
         .onSuccess(setState) { .presentProfile($0) }

      events.reactionPressed
         .doSaveResult()
         .doNext(works.pressLike)
         .onFail {
            print("failed to like")
         }
         .doLoadResult()
         .onFail {
            print("fail")
         }
         .doNext(works.createStatRequest)
         .onFail {
            print("fail")
         }
         .doNext(works.getLikesCommentsStat)
         .onFail {
            print("fail")
         }
         .doMap { [weak self] stat in
            let index = self?.events.reactionPressed.result?.index ?? 0
            let res = (stat, index)
            return res
         }
         .doNext(works.updateFeedElement)
         .onSuccess(setState) {
            .updateFeedAtIndex($0.0, $0.1)
         }
         
         
      

//         .doNext(works.getLikesCommentsStat)
//         .onFail(setState, .loadFeedError)
//         .doNext(works.getAllFeed)
//         .onSuccess(setState) { .presentFeed($0) }
//         .onFail(setState, .loadFeedError)

      events.presentDetail
         .doNext(works.getFeedByRowNumber)
         .onSuccess(setState) { .presentDetailView($0) }
         .onFail {
            print("fail ")
         }

      events.pagination
         .doNext(works.pagination)
         .onSuccess(setState) {
            .presentFeed($0)
         }
//         .onFail{ print("fail") }
//         .doVoidNext(works.getAllFeed)
//         .onSuccess(setState) { .updateFeed($0.0) }
   }
}
