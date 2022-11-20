//
//  ProfileEditScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.09.2022.
//

import ReactiveWorks
import UIKit

struct ProfileEditEvents {
   let contactsEvents: WorkVoid<Contacts>
   let saveButtonDidTap: WorkVoid<Void>
   var saveSuccess: UserData?
}

final class ProfileEditScenario<Asset: AssetProtocol>: BaseScenario<ProfileEditEvents, ProfileEditState, ProfileEditWorks<Asset>> {
   override func start() {
      works.loadProfile
         .doAsync()
         .onSuccess(setState) { .userDataDidLoad($0) }
         .onFail(setState, .error)

      events.contactsEvents
         .onSuccess {
            log($0)
            self.works.updateStorage
               .doAsync($0)
               .onSuccess {
                  log("updated")
               }
               .onFail {
                  log("failed")
               }
         }
      
      events.saveButtonDidTap
         .onSuccess {
            self.works.sendRequests
               .doAsync()
               .onSuccess(self.setState) { .finishSaveSuccess }
               .onFail {
                  print("bye")
               }
         }
   }
}
