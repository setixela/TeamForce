//
//  FeedWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation
import ReactiveWorks

protocol FeedWorksProtocol {
   var loadFeedForCurrentUser: Work<UserData?, [Feed]> { get }

   var getAllFeed: VoidWork<[Feed]> { get }
   var getMyFeed: VoidWork<[Feed]> { get }
   var getPublicFeed: VoidWork<[Feed]> { get }
}

final class FeedWorksTempStorage: InitProtocol {
   lazy var feed = [Feed]()
   lazy var currentUserName = ""
}

final class FeedWorks<Asset: AssetProtocol>: BaseSceneWorks<FeedWorksTempStorage, Asset>, FeedWorksProtocol {
   private lazy var apiUseCase = Asset.apiUseCase

   var loadFeedForCurrentUser: Work<UserData?, [Feed]> { .init { [weak self] work in
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
            work.success(result: $0)
         }
         .onFail {
            work.fail(())
         }
   }}

   var getAllFeed: VoidWork<[Feed]> { .init { work in
      work.success(result: Self.store.feed)

   }}

   var getMyFeed: VoidWork<[Feed]> { .init { work in
      let filtered = Self.store.feed.filter {
         let senderName = $0.transaction.sender
         let myName = Self.store.currentUserName
         return myName == senderName
      }
      work.success(result: filtered)
   }}

   var getPublicFeed: VoidWork<[Feed]> { .init { work in
      let filtered = Self.store.feed.filter {
         $0.transaction.isAnonymous == false
      }
      work.success(result: filtered)
   }}
}
