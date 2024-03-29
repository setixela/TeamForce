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
   let presentDetails: WorkVoid<Void>
   let presentComment: WorkVoid<Void>
   let presentReactions: WorkVoid<Void>
   let reactionPressed: WorkVoid<Void>
   let userAvatarPressed: WorkVoid<Int>

   let saveInput: WorkVoid<TransactDetailsSceneInput>

   let didEditingComment: WorkVoid<String>
   let didSendCommentPressed: WorkVoidVoid

   let presentAllReactions: WorkVoid<Void>
   let presentLikeReactions: WorkVoid<Void>
   //  let presentDislikeReactions: VoidWork<Void>
}

final class TransactDetailsScenario<Asset: AssetProtocol>:
   BaseScenario<FeedDetailEvents, FeedDetailSceneState, TransactDetailsWorks<Asset>>, Assetable
{
   override func start() {
      works.loadToken
         .doAsync()
         .onFail(setState, .error)

      events.reactionPressed
         .doNext(works.isLikedByMe)
         .onSuccess(setState) { .buttonLikePressed(alreadySelected: $0) }
         .doVoidNext(works.pressLike)
         .onFail(setState) { .failedToReact(alreadySelected: $0) }
         .doVoidNext(works.getTransactStat)
         .onSuccess(setState) { .updateReactions($0) }

      events.saveInput
         .doSaveResult()
         .doVoidNext(works.getCurrentUserName)
         .onSuccessMixSaved(setState) { (userName: String, input: TransactDetailsSceneInput) in
            switch input {
            case .feedElement(let feed):
               return .present(feed: feed, currentUsername: userName)
            case .transactId:
               return .initial
            }
         }
         .doLoadResult()
         .doNext(works.saveInput)
         .doSaveResult()
         .doVoidNext(works.getCurrentUserName)
         .onSuccessMixSaved(setState) {
            (userName: String, transaction: EventTransaction) in
               .presentDetails(transaction: transaction, currentUsername: userName)
         }
//         .onSuccess(setState) { transactDetails in
//            .presentDetails(transactDetails)
//         }

      events.presentDetails
         .doCancel(events.presentComment, events.presentReactions)
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getTransaction)
         .doSaveResult()
         .doVoidNext(works.getCurrentUserName)
         .onSuccessMixSaved(setState) {
            (userName: String, transaction: EventTransaction) in
               .presentDetails(transaction: transaction, currentUsername: userName)
         }
         //.onSuccess(setState) { .presentDetails($0) }

      events.presentComment
         .doCancel(events.presentDetails, events.presentReactions)
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getComments)
         .onSuccess(setState) { .presentComments($0) }
         .onFail(setState) { .presentComments([]) }

      events.presentReactions
         .doCancel(events.presentDetails, events.presentComment)
         .onSuccess(setState, .presntActivityIndicator)
         .doNext(works.getLikesByTransaction)
         .doNext(works.getSelectedReactions)
         .onSuccess(setState) {
            if $0.isEmpty {
               return .hereIsEmpty
            }
            return .presentReactions($0)
         }
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

      events.userAvatarPressed
         .onSuccess(setState) { .presentUserProfile($0) }
   }
}
