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
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   Void
>, Scenarible {
   //
   
   lazy var scenario: Scenario = NotificationsScenario(
      works: NotificationsWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: NotificationsEvents(
         didSelectIndex: notifyViewModel.on(\.didSelectRow)
      )
   )

   private lazy var notifyViewModel = NotificationsViewModel<Design>()

   override func start() {
      super.start()

      vcModel?.title = "Уведомления"
      vcModel?.on(\.viewDidLoad, self) {
         $0.configure()
      }
   }
}

extension NotificationsScene: Configurable {
   func configure() {
      mainVM.headerStack.arrangedModel(Spacer(8))
      mainVM.bodyStack.arrangedModel(notifyViewModel)

      scenario.start()
   }
}

enum NotificationsState {
   case initial
   case notificationsList([Notification])
}

extension NotificationsScene: StateMachine {
   func setState(_ state: NotificationsState) {
      switch state {
      case .initial:
         break
      case .notificationsList(let notifications):
         notifyViewModel.setState(.tableData(notifications))
      }
   }
}
