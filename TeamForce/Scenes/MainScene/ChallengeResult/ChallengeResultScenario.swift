//
//  ChallengeResultScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.10.2022.
//

import ReactiveWorks

struct ChallengeResultEvents {
   let commentInputChanged: VoidWork<String>
}

final class ChallengeResultScenario<Asset: AssetProtocol>: BaseScenario<ChallengeResultEvents, ChallengeResultSceneState, ChallengeResultWorks<Asset>> {

   override func start() {
      events.commentInputChanged
         .doNext(work: works.reasonInputParsing)
         .onSuccess(setState, .sendingEnabled)
         .onFail(setState, .sendingDisabled)
   }
}
