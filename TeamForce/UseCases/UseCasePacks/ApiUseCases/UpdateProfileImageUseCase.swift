//
//  UpdateProfileImageUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 19.08.2022.
//

import ReactiveWorks
import UIKit

struct UpdateProfileImageUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let updateProfileImageApiWorker: UpdateProfileImageApiWorker
   
   var work: Work<UpdateImageRequest, Void> {
      Work<UpdateImageRequest, Void> { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail()
            }
            .doMap {
               guard
                  let id = work.input?.id,
                  let photo = work.input?.photo
               else { return nil }
               let cropped = work.input?.croppedPhoto
               return UpdateImageRequest(token: $0,
                                         id: id,
                                         photo: photo,
                                         croppedPhoto: cropped)
            }
            .doNext(worker: updateProfileImageApiWorker)
            .onSuccess {
               work.success()
            }
            .onFail {
               work.fail()
            }
      }
   }
}
