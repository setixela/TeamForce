//
//  ChallengesWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

protocol ChallengesWorksProtocol {
   var testWork: VoidWorkVoid { get }
   var getChallenges: Work<Void, [Challenge]> { get }
   var getChallengeById: Work<Int, Challenge> { get }
   var getChallengeContenders: Work<Int, [Contender]>  { get }
}

final class ChallengesWorks<Asset: AssetProtocol>:
   BaseSceneWorks<BalanceWorksStorage, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
}

extension ChallengesWorks: ChallengesWorksProtocol {
   var testWork: VoidWorkVoid { .init { work in

   }.retainBy(retainer) }
   
   var getChallenges: Work<Void, [Challenge]> { .init { [weak self] work in
      self?.apiUseCase.getChanllenges
         .doAsync()
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getChallengeById: Work<Int, Challenge> { .init{ [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.GetChallengeById
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var getChallengeContenders: Work<Int, [Contender]> { .init{ [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.GetChallengeContenders
         .doAsync(input)
         .onSuccess {
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
   
   var createChallenge: Work<ChallengeRequestBody, Void> { .init{ [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.CreateChallenge
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}
