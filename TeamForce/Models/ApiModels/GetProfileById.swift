//
//  GetProfileById.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 13.09.2022.
//

import ReactiveWorks

final class GetProfileByIdApiWorker: BaseApiWorker<RequestWithId, UserData> {
   override func doAsync(work: Work<RequestWithId, UserData>) {
      guard
         let request = work.input
      else {
         work.fail(())
         return
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.ProfileById(id: String(request.id), headers: [
            "Authorization": request.token,
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let profile: UserData = decoder.parse(data)
            else {
               work.fail(())
               return
            }
            work.success(result: profile)
         }
         .catch { _ in
            work.fail(())
         }
   }
}
