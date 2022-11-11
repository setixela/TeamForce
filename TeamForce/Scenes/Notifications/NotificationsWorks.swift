//
//  NotificationsWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import ReactiveWorks
import UIKit

final class NotificationsStore: InitProtocol {
   var notifications: [Notification] = []
}

protocol NotificationsWorksProtocol: StoringWorksProtocol, Assetable
where Asset: AssetProtocol, Temp == NotificationsStore
{
   var apiUseCase: ApiUseCase<Asset> { get }

   var getNotifications: Work<Void, [Notification]> { get }
   var getNotificationByIndex: Work<Int, Notification> { get }
}

extension NotificationsWorksProtocol {
   var getNotifications: Work<Void, [Notification]> { .init { [weak self] work in
      let pagination = Pagination(offset: 1, limit: 20)
      self?.apiUseCase.getNotifications
         .doAsync(pagination)
         .onSuccess {
            Self.store.notifications = $0
            work.success($0)
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }

   var getNotificationByIndex: Work<Int, Notification> {
      .init {
         $0.success(Self.store.notifications[$0.unsafeInput])
      }.retainBy(retainer)
   }
}

final class NotificationsWorks<Asset: AssetProtocol>: BaseSceneWorks<NotificationsStore, Asset>,
                                                      NotificationsWorksProtocol {
   let apiUseCase = Asset.apiUseCase
}
