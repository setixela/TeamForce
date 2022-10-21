//
//  ChallengeDetailsWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks
import Foundation

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
   var currentContender: Contender?
   var contenders: [Contender] = []
   var reportId: Int?
   var profileId: Int?

   var winnersReports: [ChallengeWinnerReport] = []

   var inputComment = ""
   
   var filterButton = 0
}


final class ChallengeDetailsWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeDetailsWorksStore, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase

   typealias Button6Result = Result6<
      Challenge,
      [ChallengeResult],
      [Contender],
      [ChallengeWinnerReport],
      [Comment],
      Void
   >

   var filterButtonWork: Work<Button6Event, Button6Result> { .init { [weak self] work in
      guard let self, let button = work.input else { return }

      // TODO: - В документации не забыть написать про возможную ошибку в очереди асинк синк
      switch button {
      case .didTapButton1:
         self.getChallengeById
            .doAsync()
            .onSuccess { work.success(.result1($0)) }
            .onFail { work.fail() }

      case .didTapButton2:
         self.getChallengeResult
            .doAsync()
            .onSuccess { work.success(.result2($0)) }
            .onFail { work.fail() }

      case .didTapButton3:
         self.amIOwnerCheck
            .doAsync()
            .onSuccess {
               self.getChallengeContenders
                  .doAsync()
                  .onSuccess { work.success(.result3($0)) }
                  .onFail { work.fail() }
            }
            .onFail { work.fail() }

      case .didTapButton4:
         self.getChallengeWinnersReports
            .doAsync()
            .onSuccess { work.success(.result4($0)) }
            .onFail { work.fail() }

      case .didTapButton5:
         self.getComments
            .doAsync()
            .onSuccess { work.success(.result5($0)) }
            .onFail { work.fail() }
      case .didTapButton6:
         break
      }
   }.retainBy(retainer) }

   var amIOwnerCheck: Work<Void, Void> { .init { work in
      guard
         let profileId = Self.store.profileId,
         let creatorId = Self.store.challenge?.creatorId
      else { return }

      if profileId == creatorId {
         work.success(())
      } else {
         work.fail()
      }
   }.retainBy(retainer) }

   var saveInput: Work<ChallengeDetailsSceneInput, ChallengeDetailsSceneInput> { .init { work in
      guard let input = work.input else { return }
      Self.store.challenge = input.challenge
      Self.store.challengeId = input.challenge.id
      Self.store.profileId = input.profileId
      Self.store.filterButton = input.currentButton

      work.success(result: input)
   }.retainBy(retainer) }

   var getChallengeId: Work<Void, Int> { .init { work in
      guard let id = Self.store.challengeId else { return }
      work.success(id)
   }.retainBy(retainer) }

   var getChallenge: Work<Void, Challenge> { .init { work in
      guard let challenge = Self.store.challenge else { return }
      work.success(challenge)
   }.retainBy(retainer) }

   var getProfileId: Work<Void, Int> { .init { work in
      guard let id = Self.store.profileId else { return }
      work.success(id)
   }.retainBy(retainer) }

   var getInputForCancel: Work<Int, (Challenge, Int, Int)> { .init { work in
      guard
         let resultId = work.input,
         let challenge = Self.store.challenge,
         let profileId = Self.store.profileId
      else { return }

      work.success((challenge, profileId, resultId))
   }.retainBy(retainer) }

   var getInputForReportDetail: Work<Int, (Challenge, Int, Int)> { .init { work in
      guard
         let challenge = Self.store.challenge,
         let profileId = Self.store.profileId,
         let reportId = work.input
      else { return }

      work.success((challenge, profileId, reportId))
   }.retainBy(retainer) }

   var isSendResultActive: Work<Void, Void> { .init { work in
      guard let challenge = Self.store.challenge else { return }

      if challenge.active == true,
         challenge.approvedReportsAmount < challenge.awardees
      {
         work.success(())
      } else {
         work.fail()
      }
   }.retainBy(retainer) }

   var getWinnerReportIdByIndex: Work<Int, Int> { .init { work in
      let id = Self.store.winnersReports[work.unsafeInput].id
      work.success(id)
   }.retainBy(retainer) }
}

extension ChallengeDetailsWorks: ChallengeDetailsWorksProtocol {
   var getChallengeById: Work<Void, Challenge> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeById
         .doAsync(id)
         .onSuccess {
            Self.store.challenge = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getChallengeContenders: Work<Void, [Contender]> { .init { [weak self] work in
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
   }.retainBy(retainer) }

   var getChallengeWinners: Work<Void, [ChallengeWinner]> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeWinners
         .doAsync(id)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getChallengeWinnersReports: Work<Void, [ChallengeWinnerReport]> { .init { [weak self] work in
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
   }.retainBy(retainer) }

   var checkChallengeReport: Work<(CheckReportRequestBody.State, Int), Void> { .init { [weak self] work in
      guard
         let state = work.input?.0,
         let id = work.input?.1
      else { return }

      let request = CheckReportRequestBody(id: id, state: state, text: "")
      self?.apiUseCase.CheckChallengeReport
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getChallengeResult: Work<Void, [ChallengeResult]> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeResult
         .doAsync(id)
         .onSuccess {
            work.success($0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getComments: Work<Void, [Comment]> { .init { [weak self] work in
      guard let challengeId = Self.store.challengeId else { return }
      let request = CommentsRequest(token: "",
                                    body: CommentsRequestBody(
                                       challengeId: challengeId,
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
         let id = Self.store.challengeId
      else { return }

      let body = CreateCommentBody(challengeId: id, text: Self.store.inputComment)
      let request = CreateCommentRequest(token: "", body: body)

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
}
