//
//  FeedDetailWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import Foundation
import ReactiveWorks

final class FeedDetailWorksTempStorage: InitProtocol {
   lazy var currentUserName = ""
   var currentTransactId: Int?
   var currentFeed: Feed?
   var userLiked: Bool = false
   var userDisliked: Bool = false
   var token: String?
   
   var likes: [Like]?

   var inputComment = ""
}

final class FeedDetailWorks<Asset: AssetProtocol>: BaseSceneWorks<FeedDetailWorksTempStorage, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
   private lazy var storeUseCase = Asset.storageUseCase

   var loadToken: VoidWorkVoid { .init { [weak self] work in
      self?.storeUseCase.loadToken
         .doAsync()
         .onSuccess {
            Self.store.token = $0
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

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
                                       includeName: true,
                                       isReverseOrder: true
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

   var updateInputComment: Work<String, String> { .init { work in
      Self.store.inputComment = work.unsafeInput
      work.success(result: work.unsafeInput)
   }.retainBy(retainer) }

   var createComment: Work<Void, Void> { .init { [weak self] work in
      guard
         let token = Self.store.token,
         let id = Self.store.currentTransactId
      else { return }

      let body = CreateCommentBody(transaction: id, text: Self.store.inputComment)
      let request = CreateCommentRequest(token: token, body: body)

      self?.apiUseCase.createComment
         .doAsync(request)
         .onSuccess {
            work.success()
            Self.store.inputComment = ""
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
   
   var getLikesByTransaction: Work<Void, Void> { .init { [weak self] work in
      // input 1 for likes
      // input 2 for dislikes
      guard
         let transactId = Self.store.currentTransactId
      else { return }

      let request = LikesByTransactRequest(token: "", body: LikesByTransactBody(transactionId: transactId,
                              includeName: true))

      self?.apiUseCase.getLikesByTransaction
         .doAsync(request)
         .onSuccess {
            Self.store.likes = $0
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getAllReactions: VoidWork<[ReactItem]> { .init { work in
      let filtered = Self.filteredAll()
      work.success(result: filtered)
   }}
   
   var getLikeReactions: VoidWork<[ReactItem]> { .init { work in
      let filtered = Self.filteredLikes()
      work.success(result: filtered)
   }}
   
   var getDislikeReactions: VoidWork<[ReactItem]> { .init { work in
      let filtered = Self.filteredDislikes()
      work.success(result: filtered)
   }}
}

private extension FeedDetailWorks {
   static func filteredAll() -> [ReactItem] {
      guard let likes = store.likes else {
         return []
      }

      var items: [ReactItem] = []
      for like in likes {
         items += like.items ?? []
      }
      return items
   }

   static func filteredLikes() -> [ReactItem] {
      guard let likes = store.likes else {
         return []
      }

      var items: [ReactItem] = []
      for like in likes {
         if like.likeKind?.code == "like" {
            items += like.items ?? []
         }
      }
      return items
   }

   static func filteredDislikes() -> [ReactItem] {
      guard let likes = store.likes else {
         return []
      }

      var items: [ReactItem] = []
      for like in likes {
         if like.likeKind?.code == "dislike" {
            items += like.items ?? []
         }
      }
      return items
   }
}
