//
//  ProfileEditScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.09.2022.
//

import ReactiveWorks
import UIKit

struct ProfileEditEvents {
   let contactsEvents: VoidWork<Contacts>
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
         }
   }
}
