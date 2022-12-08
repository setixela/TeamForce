//
//  StatusSelectorScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

struct StatusSelectorInputEvents {
   let didSelectStatus: Work<Void, Int>
}

struct StatusSelectorScenarioParams<Asset: ASP>: ScenarioParams {
   typealias ScenarioInputEvents = StatusSelectorInputEvents
   typealias ScenarioModelState = StatusSelectorState
   typealias ScenarioWorks = StatusSelectorWorks<Asset>
}

final class StatusSelectorScenario<Asset: ASP>: BaseAssettableScenario<StatusSelectorScenarioParams<Asset>> {
   override func start() {
      works.loadUserStatusList
         .doAsync()
         .doNext(works.getUserStatusList)
         .onSuccess(setState) { .presentStatusList($0) }

      events.didSelectStatus
         .doNext(works.getUserStatusByIndex)
         .onSuccess(setState) { .selectStatusAndDismiss($0) }
   }
}

