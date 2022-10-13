//
//  ChallengeDetailsScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

struct ChallengeDetailsInputEvents {
   let saveInputAndLoadChallenge: VoidWork<(Challenge, Int)>
//   let getContenders: VoidWork<Void>
//   let getWinners: VoidWork<Void>
//   let checkReport: VoidWork<CheckReportRequestBody.State>
//   let didSelectContenderIndex: VoidWork<Int>
   let ChallengeResult: VoidWorkVoid
}

final class ChallengeDetailsScenario<Asset: AssetProtocol>: BaseScenario<ChallengeDetailsInputEvents,
   ChallengeDetailsState,
   ChallengeDetailsWorks<Asset>>
{
   override func start() {
      events.saveInputAndLoadChallenge
         .doNext(work: works.saveInput)
         .onSuccess(setState) { .presentChallenge($0) }
         .doVoidNext(works.getChallengeById)
         .onSuccess(setState) { .updateDetails($0) }
         // .doNext(works.saveInput)
         .doMap { _ in }
         .doNext(work: works.amIOwner)
         .onSuccess(setState, .enableContenders)
         .doMap { _ in }
         .doNext(work: works.getChallengeId)
         .doNext(work: works.getChallengeResult)
         .onSuccess(setState) { .enableMyResult($0) }

//      events.getContenders
//         .doNext(work: works.getChallengeContenders)
//         .onSuccess {
//            print("contenders => \($0)")
//         }
//
//      events.getWinners
//         .doNext(work: works.getChallengeWinners)
//         .onSuccess {
//            print("winners => \($0)")
//         }

//      events.checkReport
//         .doNext(work: works.checkChallengeReport)
//         .onSuccess {
//            print("succesfully checked")
//         }

//      events.didSelectContenderIndex
//         .doNext(work: works.getPresentedContenderByIndex)
//         .onSuccess {
//            print("succesffy took contender by index")
//         }

      events.ChallengeResult
         .doNext(work: works.getChallenge)
         .doSaveResult()
         .doVoidNext(works.getChallengeId)
         .onSuccessMixSaved(setState) {
            .presentSendResultScreen($1, $0)
         }
   }
}
