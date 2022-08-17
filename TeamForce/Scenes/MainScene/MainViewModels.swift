//
//  MainActors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

final class MainViewModels<Asset: AssetProtocol>: InitProtocol, Assetable {
   lazy var balanceButton = Design.button.tabBar
      .set(.title("Баланс"))
      .set(.image(Design.icon.coinLine))

   lazy var transactButton = Design.button.tabBar
      .set(.title("Новый перевод"))
      .set(.image(Design.icon.upload2Fill))

   lazy var historyButton = Design.button.tabBar
      .set(.title("История"))
      .set(.image(Design.icon.historyLine))
}

enum MainSceneState {
   case balance
   case transact
   case history
}

extension MainViewModels: SceneStateProtocol {
   func setState(_ state: MainSceneState) {
      switch state {
      case .balance:
         break
      case .transact:
         break
      case .history:
         break
      }
   }
}
