//
//  NotificationsWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import ReactiveWorks
import UIKit

final class NotificationsStore: InitProtocol {

}

final class NotificationsWorks<Asset: AssetProtocol>: BaseSceneWorks<NotificationsStore, Asset> {
   private lazy var apiUseCase = Asset.apiUseCase
   
   var setFcmToken: Work<Void, Void> { .init { [weak self] work in
      guard
         let deviceId = UIDevice.current.identifierForVendor?.uuidString,
         let currentFcmToken = UserDefaults.standard.string(forKey: "fcmToken")
      else {
         work.fail()
         return
      }
      print("deviceId \(deviceId)")
      print("fcmToken \(currentFcmToken)")
      let fcm = FcmToken(token: currentFcmToken, device: deviceId)
      self?.apiUseCase.setFcmToken
         .doAsync(fcm)
         .onSuccess {
            print("success")
         }
         .onFail {
            print("fail")
         }
      work.success()
   }.retainBy(retainer) }
   
   var getNotifications: Work<Void, Void> { .init { [weak self] work in
      let pagination = Pagination(offset: 1, limit: 20)
      self?.apiUseCase.getNotifications
         .doAsync(pagination)
         .onSuccess {
            print($0)
         }
         .onFail {
            print("fail")
         }
   }.retainBy(retainer) }
}
