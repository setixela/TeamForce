//
//  CreateContactApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.08.2022.
//

import Foundation
import ReactiveWorks

struct CreateContactRequest {
   let token: String
   let id: Int
   let contactId: String
   let contactType: String
   let profile: Int
}

final class CreateContactApiWorker: BaseApiWorker<CreateContactRequest, Void> {
   override func doAsync(work: Work<CreateContactRequest, Void>) {
      let cookieName = "csrftoken"
      
      guard
         let CreateContactRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail(())
         return
      }
      let endpoint = TeamForceEndpoints.UpdateProfile(
         id: String(CreateContactRequest.id),
         headers: ["Authorization": CreateContactRequest.token,
                   "X-CSRFToken": cookie.value],
         body: ["contact_id": CreateContactRequest.contactId,
                "contact_type": CreateContactRequest.contactType,
                "profile": CreateContactRequest.profile]
      )
      print("endpoint is \(endpoint)")
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            let str = String(decoding: result.data!, as: UTF8.self)
            print(str)
            print("response status \(result.response)")
            work.success(result: ())
         }
         .catch { _ in
            work.fail(())
         }
   }
}
