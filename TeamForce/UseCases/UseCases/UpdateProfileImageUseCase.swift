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
   
   var work: Work<(Int, UIImage), Void> {
      Work<(Int, UIImage), Void> { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }
            .doMap {
               guard
                  let id = work.input?.0,
                  let photo = work.input?.1
               else { return nil }
               return UpdateImageRequest(token: $0, id: id, photo: photo)
            }
            .doNext(worker: updateProfileImageApiWorker)
            .onSuccess {
               work.success(result: ())
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
