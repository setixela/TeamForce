//
//  ChallengeDetailsWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import Foundation
import ReactiveWorks

protocol ChallengeDetailsWorksProtocol {
   var getChallengeById: Work<Void, Challenge> { get }
   var getChallengeContenders: Work<Void, [Contender]> { get }
   var getChallengeWinners: Work<Void, [ChallengeWinner]> { get }
   var checkChallengeReport: Work<(CheckReportRequestBody.State, Int), Void> { get }
   var getChallenge: Work<Void, Challenge> { get }
}

final class ChallengeDetailsWorksStore: InitProtocol {
   var challenge: Challenge?
   var challengeId: Int?

   var currentUserName: String?
   var currentUserId: Int?

   var reportId: Int?

   var currentContender: Contender?
   var contenders: [Contender] = []

   var winnersReports: [ChallengeWinnerReport] = []

   var inputComment = ""

   var userLiked = false
}

final class ChallengeDetailsWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeDetailsWorksStore, Asset> {
   let apiUseCase = Asset.apiUseCase
   let storageUseCase = Asset.storageUseCase

   typealias Button6Result = Result6<
      Challenge,
      [ChallengeResult],
      [Contender],
      [ChallengeWinnerReport],
      [Comment],
      Void
   >

   // works that can be cancelled

   var getChallengeById: Work<Void, Challenge> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeById
         .doAsync(id)
         .onSuccess {
            Self.store.challenge = $0
            Self.store.userLiked = $0.userLiked ?? false
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   lazy var getChallengeResult: Work<Void, [ChallengeResult]> = .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeResult
         .doAsync(id)
         .onSuccess {
            work.success($0)
         }
         .onFail {
            work.fail()
         }
   }

   lazy var getChallengeContenders: Work<Void, [Contender]> = .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeContenders
         .doAsync(id)
         .onSuccess {
            Self.store.contenders = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }

   lazy var getChallengeWinnersReports: Work<Void, [ChallengeWinnerReport]> = .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeWinnersReports
         .doAsync(id)
         .onSuccess {
            Self.store.winnersReports = $0
            work.success(result: Self.store.winnersReports)
         }
         .onFail {
            work.fail()
         }
   }

   lazy var getComments: Work<Void, [Comment]> = .init { [weak self] work in
      guard let challengeId = Self.store.challengeId else { return }
      let request = CommentsRequest(
         token: "",
         body: CommentsRequestBody(
            challengeId: challengeId,
            includeName: true,
            isReverseOrder: true
         )
      )
      self?.apiUseCase.getComments
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }
}