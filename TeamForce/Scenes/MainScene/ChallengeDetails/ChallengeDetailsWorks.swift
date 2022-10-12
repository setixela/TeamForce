//
//  ChallengeDetailsWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

protocol ChallengeDetailsWorksProtocol {
   var getChallengeById: Work<Void, Challenge> { get }
   var getChallengeContenders: Work<Void, [Contender]> { get }
   var getChallengeWinners: Work<Void, [Contender]> { get }
   var checkChallengeReport: Work<CheckReportRequestBody.State, Void> { get }
}

final class ChallengeDetailsWorksStore: InitProtocol {
   var challenge: Challenge?
   var challengeId: Int?
   var currentContender: Contender?
   var contenders: [Contender]?
   var reportId: Int?
}

final class ChallengeDetailsWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeDetailsWorksStore, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
   
   var saveInput: Work<Challenge, Challenge> { .init { work in
      guard let input = work.input else { return }
      Self.store.challenge = input
      Self.store.challengeId = input.id

      work.success(result: input)
   }.retainBy(retainer) }
   
   var saveCurrentContender: Work<Contender, Contender> { .init { work in
      guard let input = work.input else { return }
      Self.store.currentContender = input
      Self.store.reportId = input.reportId
      
      work.success(result: input)
   }.retainBy(retainer) }
   
   var getPresentedContenderByIndex: Work<Int, Contender> { .init {  work in
      guard let contender = Self.store.contenders?[work.unsafeInput] else { return }
      Self.store.currentContender = contender
      work.success(contender)
   }.retainBy(retainer) }
}

extension ChallengeDetailsWorks: ChallengeDetailsWorksProtocol {
   var getChallengeById: Work<Void, Challenge> { .init { [weak self] work in
      guard let id = Self.store.challengeId else { return }
      self?.apiUseCase.GetChallengeById
         .doAsync(id)
         .onSuccess {
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

   var getChallengeWinners: Work<Void, [Contender]> { .init { [weak self] work in
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


   var checkChallengeReport: Work<CheckReportRequestBody.State, Void> { .init { [weak self] work in
      guard
         let input = work.input,
         let id = Self.store.reportId
      else { return }
      
      let request = CheckReportRequestBody(id: id, state: input)
      self?.apiUseCase.CheckChallengeReport
         .doAsync(request)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
}
