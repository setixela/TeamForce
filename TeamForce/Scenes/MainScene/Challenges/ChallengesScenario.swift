//
//  ChallengesScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

struct ChallengesScenarioInputEvents {}

final class ChallengesScenario<Asset: AssetProtocol>:
   BaseScenario<ChallengesScenarioInputEvents, ChallengesState, ChallengesWorks<Asset>>, Assetable
{
   override func start() {
      works.getChallenges
         .doAsync()
         .onSuccess(setState) { .presentChallenges($0) }

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

//
//      works.getChallengeWinners
//         .doAsync(18)
//         .onSuccess {
//            print("winners \($0)")
//         }
//         .onFail {
//            print("fail winners")
//         }
   }
}
