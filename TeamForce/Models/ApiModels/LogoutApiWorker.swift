//
//  LogoutApiModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.07.2022.
//

import Foundation

final class LogoutApiWorker: BaseApiWorker<TokenRequest, Void> {
   override func doAsync(work: Wrk) {
      apiEngine?
         .process(endpoint: TeamForceEndpoints.Logout())
         .done { _ in // result in
            print("Logout happened1")
            work.success(result: ())
         }
         .catch { _ in
            print("Logout failed")
            work.fail(())
         }
   }
}
