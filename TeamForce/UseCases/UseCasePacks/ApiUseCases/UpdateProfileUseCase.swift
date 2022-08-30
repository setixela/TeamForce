//
//  UpdateProfileUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 30.08.2022.
//

import ReactiveWorks
import UIKit

//struct UpdateProfileUseCase: UseCaseProtocol {
//   let safeStringStorage: StringStorageWorker
//   let updateProfileApiWorker: UpdateProfileApiWorker
//   
//   var work: Work<(Int, UIImage), Void> {
//      Work<(Int, UIImage), Void> { work in
//         safeStringStorage
//            .doAsync("token")
//            .onFail {
//               work.fail(())
//            }
//            .doMap {
//               guard
//                  let id = work.input?.0,
//                  let photo = work.input?.1
//               else { return nil }
//               return UpdateProfileRequest(token: $0, id: id, photo: photo)
//            }
//            .doNext(worker: updateProfileApiWorker)
//            .onSuccess {
//               work.success(result: ())
//            }
//            .onFail {
//               work.fail(())
//            }
//      }
//   }
//}
