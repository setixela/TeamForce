//
//  GetSendCoinSettingsApiWorker.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks

struct SendCoinSettings: Codable {
   let tags: [Tag]?
}

final class GetSendCoinSettingsApiWorker: BaseApiWorker<String, SendCoinSettings> {
   override func doAsync(work: Wrk) {
      apiEngine?
         .process(endpoint: TeamForceEndpoints.SendCoinSettings(headers: [
            "Authorization": work.input.string,
         ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let settings: SendCoinSettings = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: settings)
         }
         .catch { _ in
            work.fail()
         }
   }
}
