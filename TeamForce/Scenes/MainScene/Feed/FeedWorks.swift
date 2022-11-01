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
   var profileId: Int?
   var segmentId: Int = 0
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
   
   var getSegmentId: Work<Void, Int> { .init { work in
      work.success(Self.store.segmentId)
   }.retainBy(retainer) }
   
   var getFeedBySegment: Work<Int, ([NewFeed], String)> { .init { [weak self] work in
      guard let id = work.input else { work.fail(); return }
      switch id {
      case 0:
         self?.getAllFeed
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
      case 1:
         self?.getTransactionFeed
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
      case 2:
         self?.getChallengesFeed
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
      case 3:
         self?.getWinnersFeed
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
      default:
         work.fail()
      }
   }.retainBy(retainer) }
    
//   var loadAllSegments: Work<Void, Void> { .init { [weak self] work in
//
//   }.retainBy(retainer) }
   var loadFeedForCurrentUser: Work<UserData?, Void> { .init { [weak self] work in
      guard
         let user = work.input,
         let userName = user?.profile.tgName
      else {
         work.fail()
         return
      }
      Self.store.profileId = user?.profile.id
      Self.store.currentUserName = userName
      
      Self.store.feedOffset = 1
      Self.store.transactOffset =  1
      Self.store.challengeOffset = 1
      Self.store.winnerOffset = 1
      
      self?.getEvents
         .doAsync(false)
         .onSuccess { work.success() }
         .onFail { work.fail() }

      self?.getEventsTransact
         .doAsync(false)
         .onSuccess { work.success() }
         .onFail { work.fail() }
      self?.getEventsWinners
         .doAsync(false)
         .onSuccess { work.success() }
         .onFail { work.fail() }
      self?.getEventsChallenge
         .doAsync(false)
         .onSuccess { work.success() }
         .onFail { work.fail() }
   }.retainBy(retainer) }

   var filterWork: Work<Button4Event, ([NewFeed], String)> { .init { [weak self] work in
      guard let self, let button = work.input else { work.fail(); return }

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
            .onSuccess { work.success($0) }
            .onFail { work.fail() }

      case .didTapButton4:
         self.getWinnersFeed
            .doAsync()
            .onSuccess { work.success($0) }
            .onFail { work.fail() }
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

   typealias DetailInput = Result2<
      NewFeed,
      ChallengeDetailsSceneInput
   >
   var createInputForDetailView: Work<NewFeed, DetailInput> { .init { [weak self] work in
      guard let input = work.input else { work.fail(); return }
      switch input.objectSelector {
      case "T":
         work.success(.result1(input))
      case "Q":
         guard
            let challengeId = input.challenge?.id,
            let profileId = Self.store.profileId
         else { work.fail(); return }
         
         self?.getChallengeById
            .doAsync(challengeId)
            .onSuccess {
               let res = ChallengeDetailsSceneInput(challenge: $0,
                                                    profileId: profileId,
                                                    currentButton: 0)
               work.success(.result2(res))
            }
            .onFail { work.fail() }
      default:
         work.fail()
         break
      }
   }.retainBy(retainer) }
   
   var getChallengeById: Work<Int, Challenge> { .init { [weak self] work in
      guard let id = work.input else { return }
      self?.apiUseCase.GetChallengeById
         .doAsync(id)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getFeedByRowNumber: Work<Int, NewFeed> { .init { work in
      let segmentId = Self.store.segmentId
      var filtered: [NewFeed] = []
      if segmentId == 0 { filtered = Self.store.feed }
      else if segmentId == 1 { filtered = Self.store.transactions }
      else if segmentId == 2 { filtered = Self.store.challenges }
      else if segmentId == 3 { filtered = Self.store.winners }

      if let index = work.input {
         let feed = filtered[index]
         Self.store.currentTransactId = feed.id
         if feed.objectSelector == "T" || feed.objectSelector == "Q" {
            work.success(result: feed)
         } else {
            work.fail()
         }
         
      } else {
         work.fail()
      }
   }
   .retainBy(retainer)
   }

   var pressLike: Work<PressLikeRequest, PressLikeRequest> { .init { [weak self] work in
      guard let input = work.input else { work.fail(); return }
      self?.apiUseCase.pressLike
         .doAsync(input)
         .onSuccess {
            work.success(result: input)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var createStatRequest: Work<PressLikeRequest, LikesCommentsStatRequest> { .init { work in
      guard let input = work.input else { work.fail(); return }
      let reqBody = LikesCommentsStatRequest.Body(
         transactionId: input.body.transactionId,
         challengeId: input.body.challengeId,
         challengeReportId: input.body.challengeReportId)
      let request = LikesCommentsStatRequest(token: "", body: reqBody)
      work.success(request)

   }.retainBy(retainer) }
   
   var getIndexFromLikeRequest: Work<PressLikeRequest, Int> { .init { work in
      guard let input = work.input else { work.fail(); return }
      work.success(input.index)
   }.retainBy(retainer) }
   
   var updateFeedElement: Work<(LikesCommentsStatistics, Int), (NewFeed, Int)> { .init { [weak self] work in
      guard
         let stat = work.input?.0,
         let index = work.input?.1
      else { work.fail(); return }
      //get stats
      var likesAmount: Int?
      if let reactions = stat.likes {
         for reaction in reactions {
            if reaction.likeKind?.code == "like" {
               likesAmount = reaction.counter
            }
         }
      }
      let commentsAmount = stat.comments
      
      //get feed from array
      var tempFeed: NewFeed?
      switch Self.store.segmentId {
      case 0:
         tempFeed = Self.store.feed[index]
      case 1:
         tempFeed = Self.store.transactions[index]
      case 2:
         tempFeed = Self.store.challenges[index]
      case 3:
         tempFeed = Self.store.winners[index]
      default:
         break
      }
      //update feed
      tempFeed?.commentsAmount = commentsAmount ?? 0
      tempFeed?.likesAmount = likesAmount ?? 0
      
      if tempFeed?.transaction?.userLiked != nil {
         tempFeed!.transaction!.userLiked = !tempFeed!.transaction!.userLiked
      }
      if tempFeed?.challenge?.userLiked != nil {
         tempFeed!.challenge!.userLiked = !tempFeed!.challenge!.userLiked
      }

      guard
         let feed = tempFeed
      else { work.fail(); return }
      
      //update array
      switch Self.store.segmentId {
      case 0:
          Self.store.feed[index] = feed
      case 1:
         Self.store.transactions[index] = feed
      case 2:
         Self.store.challenges[index] = feed
      case 3:
         Self.store.winners[index] = feed
      default:
         break
      }
      //send res
      work.success((feed, index))
   }.retainBy(retainer) }

   var getLikesCommentsStat: Work<LikesCommentsStatRequest, LikesCommentsStatistics> { .init { [weak self] work in
      guard let input = work.input else { work.fail(); return }
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
      guard let input = work.input else { work.fail(); return }
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
      guard let paginating = work.input else { work.fail(); return }
      if Self.store.isFeedPaginating {
         print(Self.store.isFeedPaginating)
         work.fail()
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
      guard let paginating = work.input else { work.fail(); return }

      if Self.store.isTransactsPaginating {
         print(Self.store.isTransactsPaginating)
         work.fail()
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
      guard let paginating = work.input else { work.fail(); return }
      // create isPagination var for winners
      if Self.store.isWinnersPaginating {
         print(Self.store.isWinnersPaginating)
         work.fail()
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
      guard let paginating = work.input else { work.fail(); return }
      // create isPagination var for challenge
      if Self.store.isChallengesPaginating {
         print(Self.store.isChallengesPaginating)
         work.fail()
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
