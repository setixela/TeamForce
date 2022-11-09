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
         let deviceId = UIDevice.current.identifierForVendor?.uuidString
      else {
         work.fail()
         return
      }
      
      let fcm = FcmToken(token: "", device: deviceId)
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
}
