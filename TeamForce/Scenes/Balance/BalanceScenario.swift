//
//  BalanceScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 01.09.2022.
//

import Foundation
import ReactiveWorks

struct BalanceScenarioInputEvents {}

final class BalanceScenario<Asset: AssetProtocol>:
   BaseScenario<BalanceScenarioInputEvents, BalanceSceneState, BalanceWorks<Asset>>, Assetable
{
   override func start() {
      works.loadBalance
         .doAsync()
         .onSuccess(setState) { .balanceDidLoad($0) }
         .onFail(setState, .loadBalanceError)
   }
}
