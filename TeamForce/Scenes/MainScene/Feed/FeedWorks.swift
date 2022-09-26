//
//  FeedWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation
import ReactiveWorks

protocol FeedWorksProtocol {
   var loadFeedForCurrentUser: Work<UserData?, Void> { get }

   var getAllFeed: VoidWork<([Feed], String)> { get }
   var getMyFeed: VoidWork<([Feed], String)> { get }
   var getPublicFeed: VoidWork<([Feed], String)> { get }
}

final class FeedWorksTempStorage: InitProtocol {
   var feed: [Feed]?
   lazy var currentUserName = ""
   var segmentId: Int?
}

final class FeedWorks<Asset: AssetProtocol>: BaseSceneWorks<FeedWorksTempStorage, Asset>, FeedWorksProtocol {
   private lazy var apiUseCase = Asset.apiUseCase

   var loadFeedForCurrentUser: Work<UserData?, Void> { .init { [weak self] work in
      guard
         let user = work.input,
         let userName = user?.profile.tgName
      else {
         work.fail()
         return
      }
      Self.store.currentUserName = userName

      self?.apiUseCase.getFeed
         .doAsync()
         .onSuccess {
            Self.store.feed = $0
            work.success()
         }
         .onFail {
            work.fail()
         }
   }}

   var getAllFeed: VoidWork<([Feed], String)> { .init { work in
      Self.store.segmentId = 0
      let filtered = Self.filteredAll()
      work.success(result: (filtered, Self.store.currentUserName))
   }}

   var getMyFeed: VoidWork<([Feed], String)> { .init { work in
      let filtered = Self.filteredMy()
      Self.store.segmentId = 1
      work.success(result: (filtered, Self.store.currentUserName))
   }}

   var getPublicFeed: VoidWork<([Feed], String)> { .init { work in
      let filtered = Self.filteredPublic()
      Self.store.segmentId = 2
      work.success(result: (filtered, Self.store.currentUserName))
   }}

   var getFeedByRowNumber: Work<(IndexPath, Int), Feed> { .init { work in
      let segmentId = Self.store.segmentId
      var filtered: [Feed] = []
      if segmentId == 0 { filtered = Self.filteredAll() }
      else if segmentId == 1 { filtered = Self.filteredMy() }
      else if segmentId == 2 { filtered = Self.filteredPublic() }
      
      if let index = work.input?.1 {
         let feed = filtered[index]
         work.success(result: feed)
      } else {
         work.fail()
      }
   }
   .retainBy(retainer)
   }

   var pressLike: Work<PressLikeRequest, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.pressLike
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getTransactStat: Work<TransactStatRequest, TransactStatistics> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.getTransactStatistics
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getComments: Work<CommentsRequest, [Comment]> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.getComments
         .doAsync(input)
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
}

private extension FeedWorks {
   static func filteredAll() -> [Feed] {
      guard let feed = store.feed else {
         return []
      }
      
      return feed
   }
   
   static func filteredMy() -> [Feed] {
      guard let feed = store.feed else {
         return []
      }
      
      return feed.filter {
         let senderName = $0.transaction.sender
         let recipientName = $0.transaction.recipient
         let myName = Self.store.currentUserName
         return myName == senderName || myName == recipientName
      }
   }
   
   static func filteredPublic() -> [Feed] {
      guard let feed = store.feed else {
         return []
      }
      
      return feed.filter {
         $0.transaction.isAnonymous == false
      }
   }
}
