//
//  FeedDetailWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import Foundation
import ReactiveWorks

final class FeedDetailWorksTempStorage: InitProtocol {
   var currentUserName = ""
   var currentTransactId: Int?
   var currentFeed: Feed?
   var userLiked: Bool = false
//   var userDisliked: Bool = false
   var token: String?

   var likes: [Like]?

   var inputComment = ""
   var reactionSegment = 0
   var transaction: EventTransaction?
}

final class TransactDetailsWorks<Asset: AssetProtocol>: BaseWorks<FeedDetailWorksTempStorage, Asset>,
   CurrentUserStorageWorksProtocol
{
   private lazy var apiUseCase = Asset.apiUseCase
   private lazy var storeUseCase = Asset.storageUseCase

   var loadToken: WorkVoidVoid { .init { [weak self] work in
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

   var saveInput: Work<TransactDetailsSceneInput, EventTransaction> { .init { [weak self] work in
      guard let input = work.input else { return }

      switch input {
      case .feedElement(let input):
         Self.store.currentFeed = input
         Self.store.currentTransactId = input.transaction?.id
         Self.store.userLiked = input.transaction?.userLiked ?? false
         //      Self.store.userDisliked = input.0.transaction.userDisliked ?? false
         if let transactionId = input.transaction?.id {
            self?.getEventsTransactById
               .doAsync(transactionId)
               .onSuccess {
                  Self.store.transaction = $0
                  Self.store.userLiked = $0.userLiked
                  work.success(result: $0)
               }
         } else {
            work.fail()
         }
      case .transactId(let transactionId):
         Self.store.currentTransactId = transactionId
         self?.getEventsTransactById
            .doAsync(transactionId)
            .onSuccess {
               Self.store.transaction = $0
               Self.store.userLiked = $0.userLiked
               work.success(result: $0)
            }
      }
   }.retainBy(retainer) }

   var getTransaction: WorkVoid<EventTransaction> { .init { work in
      guard let transaction = Self.store.transaction else {
         work.fail()
         return
      }
      work.success(result: transaction)
   }}

   var pressLike: Work<Void, Bool> { .init { [weak self] work in
      guard let tId = Self.store.currentTransactId else { work.fail(Self.store.userLiked); return }

      let body = PressLikeRequest.Body(likeKind: 1, transactionId: tId)
      let request = PressLikeRequest(token: "", body: body, index: 0)

      self?.apiUseCase.pressLike
         .doAsync(request)
         .onSuccess {
            if body.likeKind == 1 {
               Self.store.userLiked = !Self.store.userLiked
//               Self.store.userDisliked = false
            } else if body.likeKind == 2 {
//               Self.store.userDisliked = !Self.store.userDisliked
               Self.store.userLiked = false
            }
            work.success(result: Self.store.userLiked)
         }
         .onFail {
            work.fail(Self.store.userLiked)
         }
   }.retainBy(retainer) }

   var getTransactStat: Work<Void, (LikesCommentsStatistics, Bool /* , Bool */ )> { .init { [weak self] work in
      guard let transactId = Self.store.currentTransactId else { return }
      let body = LikesCommentsStatRequest.Body(transactionId: transactId)
      let request = LikesCommentsStatRequest(token: "", body: body)
      self?.apiUseCase.getLikesCommentsStat
         .doAsync(request)
         .onSuccess {
            let likes = (Self.store.userLiked /* , Self.store.userDisliked */ )
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

   var getAllReactions: WorkVoid<[ReactItem]> { .init { work in
      let filtered = Self.filteredAll()
      Self.store.reactionSegment = 0
      work.success(result: filtered)
   }}

   var getLikeReactions: WorkVoid<[ReactItem]> { .init { work in
      let filtered = Self.filteredLikes()
      Self.store.reactionSegment = 1
      work.success(result: filtered)
   }}

   var isLikedByMe: WorkVoid<Bool> { .init { work in
      let isMyLike = Self.store.userLiked
      work.success(isMyLike)
   }.retainBy(retainer) }

//   var getDislikeReactions: VoidWork<[ReactItem]> { .init { work in
//      let filtered = Self.filteredDislikes()
//      Self.store.reactionSegment = 2
//      work.success(result: filtered)
//   }}

   var getSelectedReactions: WorkVoid<[ReactItem]> { .init { work in
      var filtered: [ReactItem] = []
      switch Self.store.reactionSegment {
      case 0:
         filtered = Self.filteredAll()
      case 1:
         filtered = Self.filteredLikes()
//      case 2:
//         filtered = Self.filteredDislikes()
      default:
         filtered = Self.filteredAll()
      }
      work.success(result: filtered)
   }}

   var getEventsTransactById: Work<Int, EventTransaction> { .init { [weak self] work in
      guard let id = work.input else { return }
      self?.apiUseCase.getEventsTransactById
         .doAsync(id)
         .onSuccess {
            print($0)
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}

private extension TransactDetailsWorks {
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

//   static func filteredDislikes() -> [ReactItem] {
//      guard let likes = store.likes else {
//         return []
//      }
//
//      var items: [ReactItem] = []
//      for like in likes {
//         if like.likeKind?.code == "dislike" {
//            items += like.items ?? []
//         }
//      }
//      return items
//   }
}
