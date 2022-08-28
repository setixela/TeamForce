//
//  FeedWorks.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation
import ReactiveWorks

protocol FeedWorksProtocol {
   var getFeed: VoidWork<[Feed]> { get }
}

final class FeedWorksTempStorage: InitProtocol {
   init() {
      lazy var feed = [Feed]()
   }
}

final class FeedWorks<Asset: AssetProtocol>: BaseSceneWorks<FeedWorksTempStorage, Asset>, FeedWorksProtocol {
   private lazy var apiUseCase = Asset.apiUseCase

   var getFeed: VoidWork<[Feed]> { apiUseCase.getFeed }
}
