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
   var getNotifySections: Work<[Notification], [TableItemsSection]> { get }
   var getNotificationByIndex: Work<Int, Notification> { get }
   var notificationReadWithId: Work<Int, Void> { get }
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

   var getNotifySections: Work<[Notification], [TableItemsSection]> { .init {
      let items = $0.unsafeInput

      guard !items.isEmpty else {
         $0.success([])
         return
      }

      var prevDay = ""

      let result = items
         .reduce([TableItemsSection]()) { result, notify in

            guard let dateString = notify.createdAt else {
               result.last?.items.append(notify)
               return result
            }

            var currentDay = dateString.dateConverted
            if let date = dateString.dateConvertedToDate {
               if Calendar.current.isDateInToday(date) {
                  currentDay = Design.Text.title.today
               } else if Calendar.current.isDateInYesterday(date) {
                  currentDay = Design.Text.title.yesterday
               }
            }

            var result = result
            if prevDay != currentDay {
               result.append(TableItemsSection(title: currentDay))
            }

            result.last?.items.append(notify)
            prevDay = currentDay
            return result
         }

      $0.success(result)
   }.retainBy(retainer) }
   
   var notificationReadWithId: Work<Int, Void> { .init { [weak self] work in
      guard let id = work.input else { work.fail(); return }
      self?.apiUseCase.notificationReadWithId
         .doAsync(id)
         .onSuccess {
            work.success()
         }
         .onFail {
            work.fail()
         }
   }.retainBy(retainer) }
}

final class NotificationsWorks<Asset: AssetProtocol>: BaseSceneWorks<NotificationsStore, Asset>,
                                                      NotificationsWorksProtocol {
   let apiUseCase = Asset.apiUseCase
}
