//
//  ChallReportDetailScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.10.2022.
//

import ReactiveWorks

struct ChallReportDetailsEvents {
   let saveInput: VoidWork<Int>
}

final class ChallReportDetailsScenario<Asset: AssetProtocol>: BaseScenario<ChallReportDetailsEvents, ChallReportDetailsSceneState, ChallReportDetailsWorks<Asset>> {

   override func start() {
      events.saveInput
         .doNext(works.getChallengeReportById)
         .onSuccess(setState) { .presentReportDetail($0) }
         .onFail { print("fail") }
   }
}
