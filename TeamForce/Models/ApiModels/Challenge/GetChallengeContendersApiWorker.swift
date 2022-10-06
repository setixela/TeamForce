//
//  GetChallengeContenders.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 06.10.2022.
//

import Foundation
import ReactiveWorks

struct Contender: Codable {
   let participantID: Int
   let participantPhoto: String?
   let participantName: String?
   let participantSurname: String?
   let reportCreatedAt: String
   let reportText: String?
   let reportPhoto: String?
   let reportId: Int
   
}

final class GetChallengeContendersApiWorker: BaseApiWorker<RequestWithId, [Contender]> {
   override func doAsync(work: Wrk) {
      let cookieName = "csrftoken"

      guard
         let input = work.input,
         let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })
      else {
         print("No csrf cookie")
         return
      }
      apiEngine?
         .process(endpoint: TeamForceEndpoints.GetChallengeContenders(
            id: String(input.id),
            headers: [
               "Authorization": input.token,
               "X-CSRFToken": cookie.value
            ]))
         .done { result in
            let decoder = DataToDecodableParser()
            guard
               let data = result.data,
               let contenders: [Contender] = decoder.parse(data)
            else {
               work.fail()
               return
            }
            work.success(result: contenders)
         }
         .catch { _ in
            work.fail()
         }
   }
}
//var getChallengeContenders: Work<Int, [Contender]> { .init{ [weak self] work in
//   guard let input = work.input else { return }
//   self?.apiUseCase.GetChallengeContenders
//      .doAsync(input)
//      .onSuccess {
//         work.success(result: $0)
//      }
//      .onFail {
//         work.fail()
//      }
//}.retainBy(retainer) }
