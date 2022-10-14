//
//  ChallengeCreateScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks

struct ChallengeCreateScenarioEvents {
   let didTitleInputChanged: VoidWork<String>
   let didDescriptionInputChanged: VoidWork<String>

   let didPrizeFundChanged: VoidWork<String>
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
   }
}
