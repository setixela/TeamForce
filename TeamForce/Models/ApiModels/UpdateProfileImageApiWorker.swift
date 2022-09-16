//
//  UpdateProfileImageApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 19.08.2022.
//

import Foundation
import ReactiveWorks
import UIKit

struct UpdateImageRequest {
   let token: String
   let id: Int
   let photo: UIImage
}

final class UpdateProfileImageApiWorker: BaseApiWorker<UpdateImageRequest, Void> {
   override func doAsync(work: Work<UpdateImageRequest, Void>) {
      let cookieName = "csrftoken"
      
      guard
         let updateImageRequest = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         work.fail()
         return
      }
      let endpoint = TeamForceEndpoints.UpdateProfileImage(
         id: String(updateImageRequest.id),
         headers: ["Authorization": updateImageRequest.token,
                   "X-CSRFToken": cookie.value]
      )
      print("endpoint is \(endpoint)")
      apiEngine?
         .processWithImage(endpoint: endpoint,
                           image: updateImageRequest.photo)
         .done { result in
            work.success()
         }
         .catch { _ in
            work.fail()
         }
   }
}
