//
//  LogoutApiModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.07.2022.
//

import Foundation

final class LogoutApiModel: BaseApiAsyncModel<TokenRequest, Void> {
   override func doAsync(work: Work) {
      apiEngine?
         .process(endpoint: TeamForceEndpoints.Logout())
         .done { _ in // result in
            print("Logout happened1")
            work.success(result: ())
         }
         .catch { _ in
            work.fail(())
         }
   }
}
