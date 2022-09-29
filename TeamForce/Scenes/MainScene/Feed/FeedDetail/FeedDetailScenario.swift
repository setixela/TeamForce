//
//  FeedDetailScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 28.09.2022.
//

import ReactiveWorks
import UIKit

import ReactiveWorks
import UIKit

struct FeedDetailEvents {
   let presentComment: VoidWork<Void>
   let presentReactions: VoidWork<Void>
}

final class FeedDetailScenario<Asset: AssetProtocol>:
   BaseScenario<FeedDetailEvents, FeedDetailSceneState, FeedDetailWorks<Asset>>, Assetable
{
   var transactId: Int?
   
   override func start() {
      if let id = transactId {
         let request = CommentsRequest(token: "",
                                       body: CommentsRequestBody(
                                          transactionId: id,
                                          includeName: true
                                       ))
         works.getComments
            .doAsync(request)
            .onSuccess(setState) { .presentComments($0)}
            .onFail {
               print("failed")
            }
      }
   }
}
