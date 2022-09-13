//
//  GetTagByIdApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 12.09.2022.
//

import ReactiveWorks

final class GetTagByIdApiWorker: BaseApiWorker<RequestWithId, Tag> {
   override func doAsync(work: Work<RequestWithId, Tag>) {
      guard
         let request = work.input
      else {
         work.fail(())
         return
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.TagById(id: String(request.id), headers: [
            "Authorization": request.token,
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let tags: Tag = decoder.parse(data)
            else {
               work.fail(())
               return
            }
            work.success(result: tags)
         }
         .catch { _ in
            work.fail(())
         }
   }
}
