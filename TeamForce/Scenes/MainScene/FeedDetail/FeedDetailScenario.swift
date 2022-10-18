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

   let didEditingComment: VoidWork<String>
   let didSendCommentPressed: VoidWorkVoid
   
   let presentAllReactions: VoidWork<Void>
   let presentLikeReactions: VoidWork<Void>
 //  let presentDislikeReactions: VoidWork<Void>
}

final class FeedDetailScenario<Asset: AssetProtocol>:
   BaseScenario<FeedDetailEvents, FeedDetailSceneState, FeedDetailWorks<Asset>>, Assetable
{
   override func start() {
      works.loadToken
         .doAsync()
         .onFail(setState, .error)

      events.reactionPressed
         .doNext(works.pressLike)
         .onFail(setState) { .failedToReact }
         .doNext(works.getTransactStat)
         .onSuccess(setState) { .updateReactions($0) }

      events.saveInput
         .doNext(works.saveInput)
         .onSuccess(setState) { .presentDetails($0) }

      events.presentDetails
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getFeed)
         .onSuccess(setState) { .presentDetails($0) }

      events.presentComment
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getComments)
         .onSuccess(setState) { .presentComments($0) }
         .onFail(setState) { .presentComments([]) }
      
      events.presentReactions
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getLikesByTransaction)
         .doNext(works.getSelectedReactions)
         .onSuccess(setState) { .presentReactions($0) }
         .onFail {
            print("failed to present reactions")
         }
      
      events.presentAllReactions
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getAllReactions)
         .onSuccess(setState) { .presentReactions($0) }
         .onFail {
            print("failed to present reactions")
         }
      
      events.presentLikeReactions
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getLikeReactions)
         .onSuccess(setState) { .presentReactions($0) }
         .onFail {
            print("failed to present reactions")
         }
      
//      events.presentDislikeReactions
//         .onSuccess(setState, .presntActivityIndicator)
//         .doNext(works.getDislikeReactions)
//         .onSuccess(setState) { .presentReactions($0) }
//         .onFail {
//            print("failed to present reactions")
//         }
         
      events.didEditingComment
         .doNext(works.updateInputComment)
         .doNext(usecase: IsEmpty())
         .onSuccess(setState, .sendButtonDisabled)
         .onFail(setState, .sendButtonEnabled)


      events.didSendCommentPressed
         .onSuccess(setState, .sendButtonDisabled)
         .doNext(works.createComment)
         .onSuccess(setState, .commentDidSend)
         .onFail(setState, .error)
   }
}
