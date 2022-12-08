//
//  ChallengeCreateScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks
import Foundation

struct ChallengeCreateScenarioEvents {
   let didTitleInputChanged: WorkVoid<String>
   let didDescriptionInputChanged: WorkVoid<String>
   let didPrizeFundChanged: WorkVoid<String>
   let didDatePicked: WorkVoid<Date>

   let didSendPressed: WorkVoidVoid
   
   let challengeTypeChanged: WorkVoid<Int>
   
   let severalReportsTurnOn: WorkVoid<Void>
   let severalReportsTurnOff: WorkVoid<Void>
   let showCandidatesTurnOn: WorkVoid<Void>
   let showCandidatesTurnOff: WorkVoid<Void>
   
}

final class ChallengeCreateScenario<Asset: AssetProtocol>: BaseScenario<ChallengeCreateScenarioEvents, ChallengeCreateSceneState, ChallengeCreateWorks<Asset>> {
   override func start() {
      
      works.createChallengeGet
         .doAsync()
         .onSuccess(setState) {
            .challengeTypesUpdate($0)
         }
         .onFail {
            print("bye")
         }
      
      events.didTitleInputChanged
         .doNext(works.setTitle)
         .doNext(works.checkAllReady)
         .onSuccess(setState) { .setReady($0) }

      events.didDescriptionInputChanged
         .doNext(works.setDesription)

      events.didPrizeFundChanged
         .doNext(works.setPrizeFund)
         .doNext(works.checkAllReady)
         .onSuccess(setState) { .setReady($0) }

      events.didSendPressed
         .onSuccess(setState, .dismissScene)
         .doNext(works.createChallenge)
         .onSuccess(setState, .challengeCreated)
         .onFail {
            print("Показать ошибку")
         }

      events.didDatePicked
         .doNext(works.setFinishDate)
         .onSuccess(setState) { .updateDateButton($0) }
      
      events.challengeTypeChanged
         .doNext(works.changeChallType)
         .onSuccess { [weak self] type in
            guard let stateFunc = self?.setState else { return }
            
            switch type {
            case "default":
               stateFunc(.defaultChall)
            case "voting":
               stateFunc(.votingChall)
            default:
               print("error")
               break
            }
         }
         .onFail {
            print("fail")
         }
      
      events.showCandidatesTurnOn
         .doNext(works.showCandidatesTurnOn)
      
      events.showCandidatesTurnOff
         .doNext(works.showCandidatesTurnOff)
      
      events.severalReportsTurnOn
         .doNext(works.severalReportsTurnOn)
      
      events.severalReportsTurnOff
         .doNext(works.severalReportsTurnOff)
   }
}
