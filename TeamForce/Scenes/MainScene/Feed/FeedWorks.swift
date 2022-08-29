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
   lazy var feed = [Feed]()
   lazy var currentUserName = ""
}

final class FeedWorks<Asset: AssetProtocol>: BaseSceneWorks<FeedWorksTempStorage, Asset>, FeedWorksProtocol {
   private lazy var apiUseCase = Asset.apiUseCase

   var loadFeedForCurrentUser: Work<UserData?, Void> { .init { [weak self] work in
      guard
         let user = work.input,
         let userName = user?.profile.nickName
      else {
         work.fail(())
         return
      }
      Self.store.currentUserName = userName

      self?.apiUseCase.getFeed
         .doAsync()
         .onSuccess {
            Self.store.feed = $0
            work.success(result: ())
         }
         .onFail {
            work.fail(())
         }
   }}

   var getAllFeed: VoidWork<([Feed], String)> { .init { work in
      work.success(result: (Self.store.feed, Self.store.currentUserName))

   }}

   var getMyFeed: VoidWork<([Feed], String)> { .init { work in
      let filtered = Self.store.feed.filter {
         let senderName = $0.transaction.sender
         let recipientName = $0.transaction.recipient
         let myName = Self.store.currentUserName
         return myName == senderName || myName == recipientName
      }
      work.success(result: (filtered, Self.store.currentUserName))
   }}

   var getPublicFeed: VoidWork<([Feed], String)> { .init { work in
      let filtered = Self.store.feed.filter {
         $0.transaction.isAnonymous == false
      }
      work.success(result: (filtered, Self.store.currentUserName))
   }}
}
