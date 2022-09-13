//
//  GetProfileByIdUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 13.09.2022.
//

import ReactiveWorks

struct GetProfileByIdUseCase: UseCaseProtocol {
   let safeStringStorage: StringStorageWorker
   let getProfileByIdApiWorker: GetProfileByIdApiWorker

   var work: Work<Int, UserData> {
      Work<Int, UserData>() { work in
         safeStringStorage
            .doAsync("token")
            .onFail {
               work.fail(())
            }
            .doMap {
               print("input")
               print(work.input)
               guard let input = work.input else { return nil }
               let request = RequestWithId(token: $0, id: input)
               return request
            }
            .doNext(worker: getProfileByIdApiWorker)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail(())
            }
      }
      
      
   }
}
