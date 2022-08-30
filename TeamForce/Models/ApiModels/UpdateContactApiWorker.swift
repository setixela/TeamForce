//
//  UpdateContactApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.08.2022.
//

import Foundation
import ReactiveWorks

struct UpdateContactRequest {
   let token: String
   let id: Int
   let contactId: String
}

final class UpdateContactApiWorker: BaseApiWorker<UpdateContactRequest, Void> {
   override func doAsync(work: Work<UpdateContactRequest, Void>) {
      let cookieName = "csrftoken"
      
      guard
         let updateContactRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail(())
         return
      }
      let endpoint = TeamForceEndpoints.UpdateContact(
         id: String(updateContactRequest.id),
         headers: ["Authorization": updateContactRequest.token,
                   "X-CSRFToken": cookie.value,
                   "Content-Type": "multipart/form-data; boundary=something"],
         body: ["contact_id": updateContactRequest.contactId]
      )
      print("endpoint is \(endpoint)")
      apiEngine?
         .process(endpoint: endpoint)
         .done { result in
            let str = String(decoding: result.data!, as: UTF8.self)
            print("result body \(str)")
            print("response status \(result.response)")
            work.success(result: ())
         }
         .catch { _ in
            work.fail(())
         }
   }
}
