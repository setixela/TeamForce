//
//  MainScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation
import ReactiveWorks

struct MainScenarioInputEvents {}

final class MainScenario<Asset: AssetProtocol>:
   BaseScenario<MainScenarioInputEvents, MainSceneState, MainWorks<Asset>>, Assetable
{
   override func start() {
      works.loadProfile
         .doAsync()
         .onSuccess(setState) { .profileDidLoad($0) }
         .onFail(setState, .loadProfileError)
   }
}
