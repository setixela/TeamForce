//
//  Asset.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks

enum ProductionAsset: AssetProtocol {
   typealias Router = MainRouter<ProductionAsset>
   typealias Text = TextBuilder
   typealias Design = DesignSystem
   typealias Service = ProductionService
   typealias Scene = Scenes

   weak static var router: MainRouter<ProductionAsset>?
}

protocol ScenesProtocol: InitProtocol {
   var digitalThanks: SceneModelProtocol { get }
   var login: SceneModelProtocol { get }
   var main: SceneModelProtocol { get }
   var profile: SceneModelProtocol { get }
   var transactionDetail: SceneModelProtocol { get }
   var challengeDetails: SceneModelProtocol { get }
   var challengeCreate: SceneModelProtocol { get }
   var challengeSendResult: SceneModelProtocol { get }
   var challengeResCancel: SceneModelProtocol { get }

   // plays
   var playground: SceneModelProtocol { get }
   var feedDetail: SceneModelProtocol { get }
}

struct Scenes: ScenesProtocol {
   var playground: SceneModelProtocol { PlaygroundScene<ProductionAsset>() }
   //
   var digitalThanks: SceneModelProtocol { DigitalThanksScene<ProductionAsset>() }
   var login: SceneModelProtocol { LoginScene<ProductionAsset>() }
   var main: SceneModelProtocol { MainScene<ProductionAsset>() }
   var profile: SceneModelProtocol { ProfileScene<ProductionAsset>() }
   var transactionDetail: SceneModelProtocol { TransactDeatilViewModel<ProductionAsset>() }
   // var profileEdit: SceneModelProtocol { ProfileEditScene<ProductionAsset>() }

   var feedDetail: SceneModelProtocol { FeedDetailScene<ProductionAsset>() }

   var challengeCreate: SceneModelProtocol { ChallengeCreateScene<ProductionAsset>() }
   var challengeSendResult: SceneModelProtocol { ChallengeResultScene<ProductionAsset>() }
   var challengeDetails: SceneModelProtocol { ChallengeDetailsScene<ProductionAsset>() }
   var challengeResCancel: SceneModelProtocol { ChallengeResCancelScene<ProductionAsset>() }
}

struct ProductionService: ServiceProtocol {
   var apiEngine: ApiEngineProtocol { ApiEngine() }
   var safeStringStorage: StringStorageProtocol { KeyChainStore() }
}

struct MockService: ServiceProtocol {
   var apiEngine: ApiEngineProtocol { ApiEngine() }
   var safeStringStorage: StringStorageProtocol { MockKeyChainStore() }
}

enum MockAsset: AssetProtocol {
   typealias Router = MainRouter<MockAsset>
   typealias Text = TextBuilder
   typealias Design = DesignSystem
   typealias Service = MockService
   typealias Scene = Scenes

   weak static var router: MainRouter<MockAsset>?
}
