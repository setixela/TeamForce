//
//  UpdateProfileApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.08.2022.
//

import Foundation
import ReactiveWorks

struct UpdateProfileRequest {
   let token: String
   let id: Int
   let info: [String : String]
}

final class UpdateProfileApiWorker: BaseApiWorker<UpdateProfileRequest, Void> {
   override func doAsync(work: Work<UpdateProfileRequest, Void>) {
      let cookieName = "csrftoken"
      
      guard
         let updateProfileRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail(())
         return
      }
      let endpoint = TeamForceEndpoints.UpdateProfile(
         id: String(updateProfileRequest.id),
         headers: ["Authorization": updateProfileRequest.token,
                   "X-CSRFToken": cookie.value],
         body: updateProfileRequest.info
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
