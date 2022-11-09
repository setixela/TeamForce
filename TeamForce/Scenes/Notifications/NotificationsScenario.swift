//
//  NotificationsScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import ReactiveWorks

struct NotificationsEvents {

}

final class NotificationsScenario<Asset: AssetProtocol>:
   BaseScenario<NotificationsEvents, NotificationsState, NotificationsWorks<Asset>>, Assetable {
   
   override func start() {
      works.retainer.cleanAll()
      works.setFcmToken
         .doAsync()
         .onSuccess {
            print("success")
         }
         .onFail {
            print("fail")
         }
      
      works.getNotifications
         .doAsync()
         .onSuccess {
            print("success")
         }
         .onFail {
            print("fail")
         }
      
   }
}
