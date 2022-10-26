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

   var getAllFeed: VoidWork<([NewFeed], String)> { get }
   var getTransactionFeed: VoidWork<([NewFeed], String)> { get }
   var getChallengesFeed: VoidWork<([NewFeed], String)> { get }
   var getWinnersFeed: VoidWork<([NewFeed], String)> { get }
}

final class FeedWorksTempStorage: InitProtocol {
   var feed: [NewFeed] = []
   var transactions: [NewFeed] = []
   var challenges: [NewFeed] = []
   var winners: [NewFeed] = []

   lazy var currentUserName = ""
   var segmentId: Int?
   var currentTransactId: Int?
   var limit = 20
   // var offset = 1

   var feedOffset = 1
   var transactOffset = 1
   var winnerOffset = 1
   var challengeOffset = 1

   var isFeedPaginating = false
   var isTransactsPaginating = false
   var isChallengesPaginating = false
   var isWinnersPaginating = false
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

      self?.getEvents
         .doAsync(false)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }

      self?.getEventsTransact
         .doAsync(false)
      self?.getEventsWinners
         .doAsync(false)
      self?.getEventsChallenge
         .doAsync(false)
   }}

   var filterWork: Work<Button4Event, ([NewFeed], String)> { .init { [weak self] work in
      guard let self, let button = work.input else { return }

      switch button {
      case .didTapButton1:
         self.getAllFeed
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }

      case .didTapButton2:
         self.getTransactionFeed
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }

      case .didTapButton3:
         self.getChallengesFeed
            .doAsync()
            .onSuccess {
               work.success($0)
            }
            .onFail {
               work.fail()
            }

      case .didTapButton4:
         self.getWinnersFeed
            .doAsync()
            .onSuccess {
               work.success($0)
            }
            .onFail {
               work.fail()
            }
      }
   }.retainBy(retainer) }

   var getAllFeed: VoidWork<([NewFeed], String)> { .init { work in
      let filtered = Self.filteredAll()
      Self.store.segmentId = 0
      work.success(result: (filtered, Self.store.currentUserName))
   }.retainBy(retainer) }

   var getTransactionFeed: VoidWork<([NewFeed], String)> { .init { work in
      let filtered = Self.filteredTransactions()
      Self.store.segmentId = 1
      work.success(result: (filtered, Self.store.currentUserName))
   }.retainBy(retainer) }

   var getChallengesFeed: VoidWork<([NewFeed], String)> { .init { work in
      let filtered = Self.filteredChallenges()
      Self.store.segmentId = 2
      work.success(result: (filtered, Self.store.currentUserName))
   }.retainBy(retainer) }

   var getWinnersFeed: VoidWork<([NewFeed], String)> { .init { work in
      let filtered = Self.filteredWinners()
      Self.store.segmentId = 3
      work.success(result: (filtered, Self.store.currentUserName))
   }.retainBy(retainer) }

   var getFeedByRowNumber: Work<Int, NewFeed> { .init { work in
      let segmentId = Self.store.segmentId
      var filtered: [NewFeed] = []
      if segmentId == 0 { filtered = Self.store.feed }
//      else if segmentId == 1 { filtered = Self.filteredMy() }
//      else if segmentId == 2 { filtered = Self.filteredPublic() }

      if let index = work.input {
         let feed = filtered[index]
         Self.store.currentTransactId = feed.id
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

   var getLikesCommentsStat: Work<LikesCommentsStatRequest, LikesCommentsStatistics> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.getLikesCommentsStat
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var pagination: Work<Bool, ([NewFeed], String)> { .init { [weak self] work in
      guard let input = work.input else { return }
      print(input)
      let username = Self.store.currentUserName
      switch Self.store.segmentId {
      case 0:
         self?.getEvents
            .doAsync(true)
            .onSuccess {
               work.success((Self.store.feed, username))
            }
            .onFail { work.fail() }
      case 1:
         self?.getEventsTransact
            .doAsync(true)
            .onSuccess {
               work.success((Self.store.transactions, username))
            }
            .onFail { work.fail() }
      case 2:
         self?.getEventsChallenge
            .doAsync(true)
            .onSuccess {
               work.success((Self.store.challenges, username))
            }
            .onFail { work.fail() }
      case 3:
         self?.getEventsWinners
            .doAsync(true)
            .onSuccess {
               work.success((Self.store.winners, username))
            }
            .onFail { work.fail() }
      default:
         work.fail()
      }
   }.retainBy(retainer) }
}

private extension FeedWorks {
   static func filteredAll() -> [NewFeed] {
      store.feed
   }

   static func filteredTransactions() -> [NewFeed] {
      store.transactions
   }

   static func filteredChallenges() -> [NewFeed] {
      store.challenges
   }

   static func filteredWinners() -> [NewFeed] {
      store.winners
   }
}

// for events works
extension FeedWorks {
   var getEvents: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { return }
      if Self.store.isFeedPaginating {
         print(Self.store.isFeedPaginating)
         return
      }
      if paginating {
         Self.store.isFeedPaginating = true
         Self.store.feedOffset += 1
      }

      let pagination = Pagination(
         offset: Self.store.feedOffset,
         limit: Self.store.limit)

      self?.apiUseCase.getEvents
         .doAsync(pagination)
         .onSuccess {
            switch paginating {
            case true:
               Self.store.isFeedPaginating = false
               Self.store.feed.append(contentsOf: $0)
            case false:
               Self.store.feed = $0
            }
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getEventsTransact: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { return }

      if Self.store.isTransactsPaginating {
         print(Self.store.isTransactsPaginating)
         return
      }
      if paginating {
         Self.store.isTransactsPaginating = true
         Self.store.transactOffset += 1
      }
      let pagination = Pagination(
         offset: Self.store.transactOffset,
         limit: Self.store.limit)
      self?.apiUseCase.getEventsTransact
         .doAsync(pagination)
         .onSuccess {
            switch paginating {
            case true:
               Self.store.isTransactsPaginating = false
               Self.store.transactions.append(contentsOf: $0)
            case false:
               Self.store.transactions = $0
            }
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getEventsWinners: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { return }
      // create isPagination var for winners
      if Self.store.isWinnersPaginating {
         print(Self.store.isWinnersPaginating)
         return
      }
      if paginating {
         Self.store.isWinnersPaginating = true
         Self.store.winnerOffset += 1
      }
      let pagination = Pagination(
         offset: Self.store.winnerOffset,
         limit: Self.store.limit)
      self?.apiUseCase.getEventsWinners
         .doAsync(pagination)
         .onSuccess {
            switch paginating {
            case true:
               Self.store.isWinnersPaginating = false
               Self.store.winners.append(contentsOf: $0)
            case false:
               Self.store.winners = $0
            }
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getEventsChallenge: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { return }
      // create isPagination var for challenge
      if Self.store.isChallengesPaginating {
         print(Self.store.isChallengesPaginating)
         return
      }
      if paginating {
         Self.store.isChallengesPaginating = true
         Self.store.challengeOffset += 1
      }
      let pagination = Pagination(
         offset: Self.store.challengeOffset,
         limit: Self.store.limit)
      self?.apiUseCase.getEventsChall
         .doAsync(pagination)
         .onSuccess {
            switch paginating {
            case true:
               Self.store.isChallengesPaginating = false
               Self.store.challenges.append(contentsOf: $0)
            case false:
               Self.store.challenges = $0
            }
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}

//
//   var updateComment: Work<UpdateCommentRequest, Void> { .init { [weak self] work in
//      guard let input = work.input else { return }
//      self?.apiUseCase.updateComment
//         .doAsync(input)
//         .onSuccess {
//            work.success()
//         }
//         .onFail {
//            work.fail()
//         }
//   }.retainBy(retainer) }
//
//   var deleteComment: Work<RequestWithId, Void> { .init { [weak self] work in
//      guard let input = work.input else { return }
//      self?.apiUseCase.deleteComment
//         .doAsync(input)
//         .onSuccess {
//            work.success()
//         }
//         .onFail {
//            work.fail()
//         }
//   }.retainBy(retainer) }
