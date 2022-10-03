//
//  FeedDetailWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import Foundation
import ReactiveWorks

final class FeedDetailWorksTempStorage: InitProtocol {
   var feed: [Feed]?
   lazy var currentUserName = ""
   var segmentId: Int?
   var currentTransactId: Int?
   var currentFeed: Feed?
   var userLiked: Bool = false
   var userDisliked: Bool = false
}

final class FeedDetailWorks<Asset: AssetProtocol>: BaseSceneWorks<FeedDetailWorksTempStorage, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase

   var saveInput: Work<(Feed, String), Feed> { .init { work in
      guard let input = work.input else { return }

      Self.store.currentFeed = input.0
      Self.store.currentTransactId = input.0.transaction.id
      Self.store.userLiked = input.0.transaction.userLiked ?? false
      Self.store.userDisliked = input.0.transaction.userDisliked ?? false
      work.success(result: input.0)
   }.retainBy(retainer) }

   var getFeed: VoidWork<Feed> { .init { work in
      guard let curFeed = Self.store.currentFeed else {
         work.fail()
         return
      }
      work.success(result: curFeed)
   }}

   var pressLike: Work<PressLikeRequest, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.pressLike
         .doAsync(input)
         .onSuccess {
            if input.likeKind == 1 {
               Self.store.userLiked = !Self.store.userLiked
               Self.store.userDisliked = false
            } else if input.likeKind == 2 {
               Self.store.userDisliked = !Self.store.userDisliked
               Self.store.userLiked = false
            }
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getTransactStat: Work<Void, (TransactStatistics, (Bool, Bool))> { .init { [weak self] work in
      guard let transactId = Self.store.currentTransactId else { return }
      let request = TransactStatRequest(token: "", transactionId: transactId)
      self?.apiUseCase.getTransactStatistics
         .doAsync(request)
         .onSuccess {
            let likes = (Self.store.userLiked, Self.store.userDisliked)
            work.success(result: ($0, likes))
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getComments: Work<Void, [Comment]> { .init { [weak self] work in
      guard let transactId = Self.store.currentTransactId else { return }
      let request = CommentsRequest(token: "",
                                    body: CommentsRequestBody(
                                       transactionId: transactId,
                                       includeName: true
                                    ))
      self?.apiUseCase.getComments
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var createComment: Work<CreateCommentRequest, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.createComment
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var updateComment: Work<UpdateCommentRequest, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.updateComment
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var deleteComment: Work<RequestWithId, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.deleteComment
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getLikesByTransaction: Work<Int, [Like]> { .init { [weak self] work in
      //input 1 for likes
      //input 2 for dislikes
      guard
         let input = work.input,
         let transactId = Self.store.currentTransactId
      else { return }

      let request = LikesByTransactRequest(token: "", body: LikesByTransactBody(transactionId: transactId, likeKind: input))

      self?.apiUseCase.getLikesByTransaction
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}
