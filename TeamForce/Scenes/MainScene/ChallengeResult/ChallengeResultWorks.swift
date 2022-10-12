//
//  ChallengeResultWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.10.2022.
//

import ReactiveWorks

final class ChallengeResultStore: InitProtocol {}

final class ChallengeResultWorks<Asset: AssetProtocol>: BaseSceneWorks<ChallengeResultStore, Asset> {}
