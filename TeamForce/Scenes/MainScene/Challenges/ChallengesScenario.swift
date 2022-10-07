//
//  ChallengesScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

final class ChallengesScenario<Asset: AssetProtocol>:
   BaseScenario<ChallengesEvents, ChallengesState, ChallengesWorks<Asset>>, Assetable {
   override func start() {
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
//      works.getChallenges
//         .doAsync()
//         .onSuccess {
//            print("challenges \($0)")
//         }
//      
//      works.getChallengeWinners
//         .doAsync(18)
//         .onSuccess {
//            print("winners \($0)")
//         }
//         .onFail {
//            print("fail winners")
//         }
//      let request = ChallengeReportBody(challengeId: 20, text: "Report text", photo: Design.icon.like)
//      works.createChallengeReport
//         .doAsync(request)
//         .onSuccess {
//            print("successful report")
//         }
//         .onFail {
//            print("failed report")
//         }
   }
}
