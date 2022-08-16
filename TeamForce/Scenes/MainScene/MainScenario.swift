//
//  MainScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

struct MainScenarioEvents {
   let presentBalanceEvent: VoidWork<Void>
   let presentTransactEvent: VoidWork<Void>
   let presentHistoryEvent: VoidWork<Void>
}

final class MainScenario<Asset: AssetProtocol>:
   BaseScenario<
      MainScenarioEvents,
      MainSceneState,
      MainBackstage<Asset>
   >
{
   override func start(stateMachineFunc: @escaping (MainSceneState) -> Void) {
      events.presentBalanceEvent
         .onSuccess {
            stateMachineFunc(.balance)
         }
      events.presentTransactEvent
         .onSuccess {
            stateMachineFunc(.transact)
         }
      events.presentHistoryEvent
         .onSuccess {
            stateMachineFunc(.history)
         }
   }
}
