//
//  ChallengesWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

protocol ChallengesWorksProtocol {
   var getChallenges: Work<Bool, [Challenge]> { get }

   var getAllChallenges: Work<Void, [Challenge]> { get }
   var getActiveChallenges: Work<Void, [Challenge]> { get }
   var getPresentedChallengeByIndex: Work<Int, Challenge> { get }
}

final class ChallengesTempStorage: InitProtocol {
   var challenges: [Challenge] = []
   var activeChallenges: [Challenge] = []
   var presentingChallenges: [Challenge] = []
   var profileId: Int?
   
   var allOffset = 1
   var activeOffset = 1
   
   var isAllPaginating = false
   var isActivePaginating = false
}

final class ChallengesWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengesTempStorage, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
}

extension ChallengesWorks: CheckInternetWorks {}

extension ChallengesWorks: ChallengesWorksProtocol {
   
   var saveProfileId: Work<UserData?, Int> { .init { work in
      guard
         let user = work.input,
         let id = user?.profile.id
      else { return }
      Self.store.profileId = id
      work.success(id)
   }.retainBy(retainer) }
   
   var getProfileId: Work<Void, Int> { .init { work in
      guard let id = Self.store.profileId else { return }
      work.success(id)
   }.retainBy(retainer) }
   
   var getChallenges: Work<Bool, [Challenge]> { .init { [weak self] work in
      guard let activeOnly = work.input else { work.fail(); return }
      
      let request = ChallengesRequest(token: "",
                                      activeOnly: activeOnly,
                                      pagination: nil)
      self?.apiUseCase.getChanllenges
         .doAsync(request)
         .onSuccess {
            Self.store.challenges = $0
            Self.store.presentingChallenges = $0
            work.success(result: $0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getAllChallenges: VoidWork<[Challenge]> { .init {  [weak self] work in
      self?.getChallenges
         .doAsync(false)
         .onSuccess {
            Self.store.challenges = $0
            Self.store.presentingChallenges = $0
            work.success($0)
         }
      Self.store.presentingChallenges = Self.store.challenges
      work.success(Self.store.presentingChallenges)
   }.retainBy(retainer) }

   var getActiveChallenges: VoidWork<[Challenge]> { .init { [weak self] work in
      self?.getChallenges
         .doAsync(true)
         .onSuccess {
            Self.store.activeChallenges = $0
            Self.store.presentingChallenges = $0
            work.success($0)
         }
         .onFail {
            work.fail()
         }
      
      //Self.store.presentingChallenges = Self.store.challenges.filter(\.active.bool)
     // work.success(Self.store.presentingChallenges)
   }.retainBy(retainer) }

   var getPresentedChallengeByIndex: Work<Int, Challenge> { .init {  work in
      work.success(Self.store.presentingChallenges[work.unsafeInput])
   }.retainBy(retainer) }

   var createChallenge: Work<ChallengeRequestBody, Void> { .init { [weak self] work in
      guard let input = work.input else { return }
      self?.apiUseCase.createChallenge
         .doAsync(input)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}
