//
//  NotificationsScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import ReactiveWorks

struct NotificationsEvents {
   let didSelectIndex: VoidWork<Int>
}

final class NotificationsScenario<Asset: AssetProtocol>:
   BaseScenario<NotificationsEvents, NotificationsState, NotificationsWorks<Asset>>, Assetable {
   
   override func start() {
      works.getNotifications
         .doAsync()
         .onFail(setState, .loadNotifyError)
         .doNext(usecase: IsNotEmpty())
         .onFail(setState, .hereIsEmpty)
         .doNext(works.getNotifySections)
         .onSuccess(setState) { .presentNotifySections($0) }

      events.didSelectIndex
         .doNext(works.getNotificationByIndex)
         .onSuccess {
//            Asset.router?.route(.pop)
//            switch $0.type {
//            case .T:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
//            case .H:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
//            case .C:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
//            case .L:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
//            case .W:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
//            case .R:
//               Asset.router?.route(.push, scene: \.transactionDetail, payload: $0.transactionData)
//            }
         }
   }
}
