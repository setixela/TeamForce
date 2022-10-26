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
   var offset = 1
   var isPaginating = false
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
   }}
   
   var filterWork: Work<Button4Event, ([NewFeed], String)> { .init { [weak self] work in
      print(work.input)
      guard let self, let button = work.input else { return }
      print(self)
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
//      Self.store.segmentId = 0
//      let filtered = Self.filteredAll()
//      work.success(result: (filtered, Self.store.currentUserName))
      self.getEvents
         .doAsync(false)
         .onSuccess {
            let filtered = Self.filteredAll()
            Self.store.segmentId = 0
            work.success(result: (filtered, Self.store.currentUserName))
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getTransactionFeed: VoidWork<([NewFeed], String)> { .init { work in
      self.getEventsTransact
         .doAsync(false)
         .onSuccess {
            let filtered = Self.filteredTransactions()
            Self.store.segmentId = 1
            work.success(result: (filtered, Self.store.currentUserName))
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getChallengesFeed: VoidWork<([NewFeed], String)> { .init { work in
      self.getEventsChallenge
         .doAsync(false)
         .onSuccess {
            let filtered = Self.filteredChallenges()
            Self.store.segmentId = 2
            work.success(result: (filtered, Self.store.currentUserName))
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getWinnersFeed: VoidWork<([NewFeed], String)> { .init { work in
      self.getEventsWinners
         .doAsync(false)
         .onSuccess {
            let filtered = Self.filteredWinners()
            Self.store.segmentId = 3
            work.success(result: (filtered, Self.store.currentUserName))
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getFeedByRowNumber: Work<(IndexPath, Int), NewFeed> { .init { work in
      let segmentId = Self.store.segmentId
      var filtered: [NewFeed] = []
      if segmentId == 0 { filtered = Self.store.feed }
//      else if segmentId == 1 { filtered = Self.filteredMy() }
//      else if segmentId == 2 { filtered = Self.filteredPublic() }
      
      if let index = work.input?.1 {
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
}

private extension FeedWorks {
   static func filteredAll() -> [NewFeed] {
      return store.feed
   }
   
   static func filteredTransactions() -> [NewFeed] {
      return store.transactions
   }
   
   static func filteredChallenges() -> [NewFeed] {
      return store.challenges
   }
   
   static func filteredWinners() -> [NewFeed] {
      return store.winners
   }
}

// for events works
extension FeedWorks {
   var getEvents: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { return }
      if Self.store.isPaginating {
         print(Self.store.isPaginating)
         return
      }
      if paginating {
         Self.store.isPaginating = true
      }
      let pagination = Pagination(offset: Self.store.offset, limit: Self.store.limit)
      self?.apiUseCase.getEvents
         .doAsync(pagination)
         .onSuccess {
            Self.store.feed.append(contentsOf: $0)
            // Self.store.offset += 1
            if paginating == true {
               Self.store.offset += 1
            }
            Self.store.isPaginating = false
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getEventsTransact: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { return }
      // create isPagination var for transact
      if Self.store.isPaginating {
         print(Self.store.isPaginating)
         return
      }
      if paginating {
         Self.store.isPaginating = true
      }
      let pagination = Pagination(offset: Self.store.offset, limit: Self.store.limit)
      self?.apiUseCase.getEventsTransact
         .doAsync(pagination)
         .onSuccess {
            Self.store.transactions = $0
            if paginating == true {
               Self.store.offset += 1
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
      if Self.store.isPaginating {
         print(Self.store.isPaginating)
         return
      }
      if paginating {
         Self.store.isPaginating = true
      }
      let pagination = Pagination(offset: Self.store.offset, limit: Self.store.limit)
      self?.apiUseCase.getEventsWinners
         .doAsync(pagination)
         .onSuccess {
            if paginating == true {
               Self.store.offset += 1
            }
            Self.store.winners = $0
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getEventsChallenge: Work<Bool, Void> { .init { [weak self] work in
      guard let paginating = work.input else { return }
      // create isPagination var for challenge
      if Self.store.isPaginating {
         print(Self.store.isPaginating)
         return
      }
      if paginating {
         Self.store.isPaginating = true
      }
      let pagination = Pagination(offset: Self.store.offset, limit: Self.store.limit)
      self?.apiUseCase.getEventsChall
         .doAsync(pagination)
         .onSuccess {
            if paginating == true {
               Self.store.offset += 1
            }
            Self.store.challenges = $0
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}

//   var getComments: Work<Void, [Comment]> { .init { [weak self] work in
//      guard let id = Self.store.currentTransactId else { return }
//      let request = CommentsRequest(token: "",
//                                    body: CommentsRequestBody(
//                                       transactionId: id,
//                                       includeName: true
//                                    ))
//      self?.apiUseCase.getComments
//         .doAsync(request)
//         .onSuccess {
//            work.success(result: $0)
//         }
//         .onFail {
//            work.fail()
//         }
//   }.retainBy(retainer) }

//   var createComment: Work<CreateCommentRequest, Void> { .init { [weak self] work in
//      guard let input = work.input else { return }
//      self?.apiUseCase.createComment
//         .doAsync(input)
//         .onSuccess {
//            work.success()
//         }
//         .onFail {
//            work.fail()
//         }
//   }.retainBy(retainer) }
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
