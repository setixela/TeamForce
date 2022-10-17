//
//  GetTagByIdUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 12.09.2022.
//

import ReactiveWorks

struct GetTagByIdUseCase: UseCaseProtocol {
   let getTagByIdApiWorker: GetTagByIdApiWorker

   var work: Work<RequestWithId, Tag> {
      Work<RequestWithId, Tag>() { work in
         guard let input = work.input else { return }
         getTagByIdApiWorker
            .doAsync(input)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail()
            }
      }
   }
}
