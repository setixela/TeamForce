//
//  ChallengesWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

protocol ChallengesWorksProtocol {
   var testWork: VoidWorkVoid { get }
}

final class ChallengesWorks<Asset: AssetProtocol>:
   BaseSceneWorks<BalanceWorksStorage, Asset> {}

extension ChallengesWorks: ChallengesWorksProtocol {
   var testWork: VoidWorkVoid { .init { work in

   }.retainBy(retainer) }
}
