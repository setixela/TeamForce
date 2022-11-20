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
}

final class ChallengeCreateScenario<Asset: AssetProtocol>: BaseScenario<ChallengeCreateScenarioEvents, ChallengeCreateSceneState, ChallengeCreateWorks<Asset>> {
   override func start() {
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
   }
}
