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

      setState(.initial)

      vcModel?.title = "Уведомления"
      vcModel?.on(\.viewDidLoad, self) {
         $0.scenario.start()
      }
   }
}

enum NotificationsState {
   case initial
   case notificationsList([Notification])
   case hereIsEmpty
}

extension NotificationsScene: StateMachine {
   func setState(_ state: NotificationsState) {
      switch state {
      case .initial:
         mainVM.headerStack.arrangedModels(Spacer(8))
         mainVM.bodyStack.arrangedModels(
            ActivityIndicator<Design>(),
            Spacer()
         )
      case .notificationsList(let notifications):
         mainVM.bodyStack.arrangedModels(notifyViewModel)
         notifyViewModel.setState(.tableData(notifications))
      case .hereIsEmpty:
         mainVM.bodyStack.arrangedModels(
            HereIsEmpty<Design>(),
            Spacer()
         )
      }
   }
}
