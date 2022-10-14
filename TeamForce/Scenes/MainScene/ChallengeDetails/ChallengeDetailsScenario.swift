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
   let filterButtonTapped: VoidWork<Button6Event>
   let acceptPressed: VoidWork<Int>
   let rejectPressed: VoidWork<Int>
}

final class ChallengeDetailsScenario<Asset: AssetProtocol>: BaseScenario<ChallengeDetailsInputEvents,
   ChallengeDetailsState,
   ChallengeDetailsWorks<Asset>>
{
   override func start() {
      events.saveInputAndLoadChallenge
         .doNext(works.saveInput)
         .onSuccess(setState) { .presentChallenge($0) }
         .doVoidNext(works.getChallengeById)
         .onSuccess(setState) { .updateDetails($0) }
         // .doNext(works.saveInput)
         .doVoidNext(works.amIOwner)
         .onSuccess(setState, .enableContenders)
         .onFail { print("you are not owner") }
         .doRecover()
         .doNext(works.getChallengeResult)
         .onSuccess(setState) { .enableMyResult($0) }

//      events.getContenders
//         .doNext(works.getChallengeContenders)
//         .onSuccess {
//            print("contenders => \($0)")
//         }
//
//      events.getWinners
//         .doNext(works.getChallengeWinners)
//         .onSuccess {
//            print("winners => \($0)")
//         }

//      events.checkReport
//         .doNext(works.checkChallengeReport)
//         .onSuccess {
//            print("succesfully checked")
//         }

//      events.didSelectContenderIndex
//         .doNext(works.getPresentedContenderByIndex)
//         .onSuccess {
//            print("succesffy took contender by index")
//         }

      events.ChallengeResult
         .doNext(works.getChallenge)
         .doSaveResult()
         .doVoidNext(works.getChallengeId)
         .onSuccessMixSaved(setState) {
            .presentSendResultScreen($1, $0)
         }
      
      events.filterButtonTapped
         .doNext(works.filterButtonWork)
         .onSuccess { [weak self] in
            // можно сет стейт достать из селфа:
            guard let stateFunc = self?.setState else { return }

            switch $0 {
            case let value as Challenge:
               stateFunc(.presentChallenge(value))
            case let value as [ChallengeResult]:
               stateFunc(.presentMyResults(value))
            case let value as [ChallengeWinner]:
               stateFunc(.presentWinners(value))
            case let value as [Contender]:
               stateFunc(.presentContenders(value))
            default:
               break
            }
         }
         .onFail {
            print("fail button works")
         }
      
      events.rejectPressed
         .doMap { (CheckReportRequestBody.State.D, $0) }
         .doNext(works.checkChallengeReport)
         .doNext(works.getChallengeContenders)
         .onSuccess(setState) { .presentContenders($0) }
         .onFail {
            print("fail")
         }
      
      events.acceptPressed
         .doMap { (CheckReportRequestBody.State.W, $0) }
         .doNext(works.checkChallengeReport)
         .doNext(works.getChallengeContenders)
         .onSuccess(setState) { .presentContenders($0) }
         .onFail { print("fail") }
   }
}
