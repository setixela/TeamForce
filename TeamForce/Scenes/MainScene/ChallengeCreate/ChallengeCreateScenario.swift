//
//  ChallengeCreateScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks
import Foundation

struct ChallengeCreateScenarioEvents {
   let didTitleInputChanged: VoidWork<String>
   let didDescriptionInputChanged: VoidWork<String>
   let didPrizeFundChanged: VoidWork<String>
   let didDatePicked: VoidWork<Date>

   let didSendPressed: VoidWorkVoid
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
         .onSuccess(setState, .continueButtonPressed)
         .doNext(works.createChallenge)
         .onSuccess(setState, .challengeCreated)
//         .onSuccess(setState, .continueButtonPressed)
//         .onFail {
//            print("Error createChallenge")
//         }

      events.didDatePicked
         .doNext(works.setFinishDate)
         .onSuccess(setState) { .updateDateButton($0) }
   }
}
