//
//  NotificationsScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import Foundation
import ReactiveWorks

final class NotificationsScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackModel,
   Asset,
   Void
> {
   //
   
}

enum NotificationsState {
   case initial
}

extension NotificationsScene: StateMachine {
   func setState(_ state: NotificationsState) {
      switch state {
      case .initial:
         break
      }
   }
}
