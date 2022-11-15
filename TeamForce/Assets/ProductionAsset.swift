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

fileprivate typealias PA = ProductionAsset

protocol ScenesProtocol: InitProtocol {
   var digitalThanks: SMP { get }
   var login: SMP { get }
   var verify: SMP { get }
   var chooseOrgScene: SMP { get }
   var main: SMP { get }

   var transactDetails: SMP { get }

   var myProfile: SMP { get }
   var profile: SMP { get }

   var sentTransactDetails: SMP { get }

   var challengeDetails: SMP { get }
   var challengeCreate: SMP { get }
   var challengeSendResult: SMP { get }
   var challengeResCancel: SMP { get }
   var challengeReportDetail: SMP { get }

   var notifications: SMP { get }

   var settings: SMP { get }

   var imageViewer: SMP { get }

   // plays
   var playground: SMP { get }
}

struct Scenes: ScenesProtocol {
   var settings: ReactiveWorks.SMP { SettingsScene<PA>() }
   //
   var playground: SMP { PlaygroundScene<PA>() }
   //
   var digitalThanks: SMP { DigitalThanksScene<PA>() }
   var login: SMP { LoginScene<PA>() }
   var verify: SMP { VerifyScene<PA>() }
   var chooseOrgScene: SMP { ChooseOrgScene<PA>() }
   var main: SMP { MainScene<PA>() }
   var myProfile: SMP { MyProfileScene<PA>() }
   var profile: SMP { ProfileScene<PA>() }
   var sentTransactDetails: SMP { SentTransactDetailsScene<PA>() }
   // var profileEdit: SMP { ProfileEditScene<PA>() }

   var transactDetails: SMP { TransactDetailsScene<PA>() }

   var challengeCreate: SMP { ChallengeCreateScene<PA>() }
   var challengeSendResult: SMP { ChallengeResultScene<PA>() }
   var challengeDetails: SMP { ChallengeDetailsScene<PA>() }
   var challengeResCancel: SMP { ChallengeResCancelScene<PA>() }
   var challengeReportDetail: SMP { ChallReportDetailsScene<PA>() }

   var notifications: SMP { NotificationsScene<PA>() }

   var imageViewer: SMP { ImageViewerScene<PA>() }
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
