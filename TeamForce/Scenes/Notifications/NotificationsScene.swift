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
>, Scenarible2 {
   //

   private lazy var works = NotificationsWorks<Asset>()

   lazy var scenario: Scenario = NotificationsScenario(
      works: works,
      stateDelegate: stateDelegate,
      events: NotificationsEvents()
   )

   lazy var scenario2: Scenario = NotificationsDetailsScenario(
      works: works,
      stateDelegate: detailsPresenter.stateDelegate,
      events: NotificationsDetailsEvents(
          didSelectIndex: notifyViewModel.on(\.didSelectRow)
      )
   )

   private lazy var notifyViewModel = NotificationsViewModel<Design>()

   // Details Presenter
   private lazy var detailsPresenter = DetailsPresenter<Asset>()

   override func start() {
      super.start()

      setState(.initial)

      vcModel?.title = "Уведомления"
      vcModel?.on(\.viewDidLoad, self) {
         $0.scenario.start()
         $0.scenario2.start()
      }
   }
}

enum NotificationsState {
   case initial
   case presentNotifySections([TableItemsSection])
   case hereIsEmpty
   case loadNotifyError
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
      case .presentNotifySections(let notifications):
         mainVM.bodyStack.arrangedModels(notifyViewModel)
         notifyViewModel.setState(.tableData(notifications))
      case .hereIsEmpty:
         mainVM.bodyStack.arrangedModels(
            HereIsEmpty<Design>(),
            Spacer()
         )
      case .loadNotifyError:
         mainVM.bodyStack.arrangedModels(CommonErrorBlock<Design>())
      }
   }
}
