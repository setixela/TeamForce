//
//  ChallengeCreateScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks

struct ChallengeCreateScenarioEvents {}

final class ChallengeCreateScenario<Asset: AssetProtocol>: BaseScenario<ChallengeCreateScenarioEvents, ChallengeCreateSceneState, ChallengeCreateWorks<Asset>> {
   override func start() {}
}
