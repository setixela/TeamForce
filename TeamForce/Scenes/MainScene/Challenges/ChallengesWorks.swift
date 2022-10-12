//
//  ChallengesWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

protocol ChallengesWorksProtocol {
   var getChallenges: Work<Void, [Challenge]> { get }

   var getAllChallenges: Work<Void, [Challenge]> { get }
   var getActiveChallenges: Work<Void, [Challenge]> { get }
   var getPresentedChallengeByIndex: Work<Int, Challenge> { get }
}

final class ChallengesTempStorage: InitProtocol {
   var challenges: [Challenge] = []
   var presentingChallenges: [Challenge] = []
}

final class ChallengesWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengesTempStorage, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
}

extension ChallengesWorks: ChallengesWorksProtocol {
   var getChallenges: Work<Void, [Challenge]> { .init { [weak self] work in
      self?.apiUseCase.getChanllenges
         .doAsync()
         .onSuccess {
            Self.store.challenges = $0
            Self.store.presentingChallenges = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getAllChallenges: VoidWork<[Challenge]> { .init {  work in
      Self.store.presentingChallenges = Self.store.challenges
      work.success(Self.store.presentingChallenges)
   }.retainBy(retainer) }

   var getActiveChallenges: VoidWork<[Challenge]> { .init {  work in
      Self.store.presentingChallenges = Self.store.challenges.filter(\.active.bool)
      work.success(Self.store.presentingChallenges)
   }.retainBy(retainer) }

   var getPresentedChallengeByIndex: Work<Int, Challenge> { .init {  work in
      work.success(Self.store.presentingChallenges[work.unsafeInput])
   }.retainBy(retainer) }

   var createChallenge: Work<ChallengeRequestBody, Void> { .init { [weak self] work in
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
