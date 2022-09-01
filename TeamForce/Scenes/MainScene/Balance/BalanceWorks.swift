//
//  BalanceWorks.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 01.09.2022.
//

import ReactiveWorks

final class BalanceWorksStorage: InitProtocol {}

protocol BalanceWorksProtocol {
   var loadBalance: VoidWork<Balance> { get }
}

final class BalanceWorks<Asset: AssetProtocol>: BaseSceneWorks<BalanceWorksStorage, Asset>, BalanceWorksProtocol {
   private lazy var apiUseCase = Asset.apiUseCase

   var loadBalance: VoidWork<Balance> { apiUseCase.loadBalance }
}
