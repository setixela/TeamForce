//
//  ChallengesScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

struct ChallengesScenarioInputEvents {
   let saveProfileId: WorkVoid<UserData?>
   
   let presentAllChallenges: WorkVoid<Void>
   let presentActiveChallenges: WorkVoid<Void>

   let didSelectChallengeIndex: WorkVoid<Int>

   let createChallenge: WorkVoidVoid
}

final class ChallengesScenario<Asset: AssetProtocol>:
   BaseScenario<ChallengesScenarioInputEvents, ChallengesState, ChallengesWorks<Asset>>, Assetable
{
   override func start() {
      works.retainer.cleanAll()

      events.saveProfileId
         .doNext(works.saveProfileId)
         .doInput(false)
         .doNext(works.getChallenges)
         .onSuccess(setState) { .presentChallenges($0) }
         .onFail(setState) { .presentError }
      
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
