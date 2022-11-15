//
//  ChallengeDetailsStoreWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.11.2022.
//

import ReactiveWorks

extension ChallengeDetailsWorks {
   var saveInput: Work<ChallengeDetailsInput, Void> { .init { [weak self] work in
      guard let self, let input = work.input else { return }

      self.saveCurrentUserData
         .doAsync()
         .onSuccess {
            switch input {
            case .byChallenge(let challenge, _):
               Self.store.challengeId = challenge.id
               work.success()
            case .byFeed(let input, _):
               switch input.objectSelector {
               case "Q":
                  guard
                     let challengeId = input.challenge?.id
                  else { work.fail(); return }

                  Self.store.challengeId = challengeId
               case "R":
                  guard
                     let reportId = input.winner?.id,
                     let challengeId = input.winner?.challengeId
                  else { work.fail(); return }

                  Self.store.reportId = reportId
                  Self.store.challengeId = challengeId
               default:
                  work.fail()
               }
            case .byId(let id, _):
               Self.store.challengeId = id
            }
            work.success()
         }
   }.retainBy(retainer) }

   var saveCurrentUserData: Work<Void, Void> { .init { [weak self] work in
      guard let self else { work.fail(); return }

      self.storageUseCase.getCurrentUserName
         .doAsync()
         .onSuccess {
            Self.store.currentUserName = $0
         }
         .doNext(self.storageUseCase.getCurrentUserId)
         .onSuccess {
            Self.store.currentUserName = $0
            work.success()
         }
   }.retainBy(retainer) }
}

extension ChallengeDetailsWorks {
   var getChallengeId: Work<Void, Int> { .init { work in
      guard let id = Self.store.challengeId else { return }
      work.success(id)
   }.retainBy(retainer) }

   var getChallenge: Work<Void, Challenge> { .init { work in
      guard let challenge = Self.store.challenge else { return }
      work.success(challenge)
   }.retainBy(retainer) }

   var getProfileId: Work<Void, Int> { .init { work in
      guard let id = Self.store.currentUserId else { return }
      work.success(id)
   }.retainBy(retainer) }

}
