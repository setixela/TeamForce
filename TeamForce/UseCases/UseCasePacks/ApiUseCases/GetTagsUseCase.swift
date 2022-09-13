//
//  GetTagsUseCase.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 12.09.2022.
//

import ReactiveWorks

struct GetTagsUseCase: UseCaseProtocol {
   let getTagsApiWorker: GetTagsApiWorker

   var work: Work<String, [Tag]> {
      Work<String, [Tag]>() { work in
         guard let input = work.input else { return }
         getTagsApiWorker
            .doAsync(input)
            .onSuccess {
               work.success(result: $0)
            }
            .onFail {
               work.fail(())
            }
      }
   }
}
