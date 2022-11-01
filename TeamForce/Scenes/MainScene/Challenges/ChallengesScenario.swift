//
//  ChallengesScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

struct ChallengesScenarioInputEvents {
   let saveProfileId: VoidWork<UserData?>
   
   let presentAllChallenges: VoidWork<Void>
   let presentActiveChallenges: VoidWork<Void>

   let didSelectChallengeIndex: VoidWork<Int>

   let createChallenge: VoidWorkVoid
}

final class ChallengesScenario<Asset: AssetProtocol>:
   BaseScenario<ChallengesScenarioInputEvents, ChallengesState, ChallengesWorks<Asset>>, Assetable
{
   override func start() {
      works.getChallenges
         .doAsync(false)
         .onSuccess(setState) { .presentChallenges($0) }
         .onFail(setState) { .presentChallenges([]) }

      events.saveProfileId
         .doNext(works.saveProfileId)
      
      events.presentAllChallenges
         .doNext(works.getAllChallenges)
         .onSuccess(setState) { .presentChallenges($0) }

      events.presentActiveChallenges
         .doNext(works.getActiveChallenges)
         .onSuccess(setState) { .presentChallenges($0) }

      events.didSelectChallengeIndex
         .doNext(works.getPresentedChallengeByIndex)
         .doSaveResult()
         .doInput(())
         .doNext(works.getProfileId)
         .onSuccessMixSaved(setState) { .presentChallengeDetails(($1, $0)) }

      events.createChallenge
         .onSuccess(setState, .presentCreateChallenge)
      
//      let input = ChallengeRequestBody(name: "Challenge 13", description: "some description", startBalance: 1)
//      works.createChallenge
//         .doAsync(input)
//         .onSuccess {
//            print("created challenge")
//         }
//         .onFail {
//            print("not created challenge")
//         }
//

   }
}
