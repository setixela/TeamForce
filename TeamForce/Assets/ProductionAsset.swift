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

private typealias PA = ProductionAsset

protocol ScenesProtocol: InitProtocol {
   //
   var digitalThanks: BaseScene<Void> { get }
   //
   var login: BaseScene<Void> { get }
   var verify: BaseScene<AuthResult> { get }
   var chooseOrgScene: BaseScene<[OrganizationAuth]> { get }
   //
   var main: BaseScene<Void> { get }
   //
   var myProfile: BaseScene<Void> { get }
   var profile: BaseScene<ProfileID> { get }
  // var diagramProfile: BaseScene<ProfileID> { get }
   var userStatusSelector: BaseScene<Void> { get }
   //
   var transactDetails: BaseScene<TransactDetailsSceneInput> { get }
   var sentTransactDetails: BaseScene<Transaction> { get }
   //
   var challengeDetails: BaseScene<ChallengeDetailsInput> { get }
   var challengeCreate: BaseScene<Void> { get }
   var challengeSendResult: BaseScene<Int> { get }
   var challengeResCancel: BaseScene<Int> { get }
   var challengeReportDetail: BaseScene<Int> { get }
   //
   var notifications: BaseScene<Void> { get }
   //
   var settings: BaseScene<UserData> { get }
   //
   var imageViewer: BaseScene<String> { get }
   
   // plays
   var playground: BaseScene<Void> { get }
}

struct Scenes: ScenesProtocol {
   //
   var digitalThanks: BaseScene<Void> { DigitalThanksScene<PA>() }
   //
   var login: BaseScene<Void> { LoginScene<PA>() }
   var verify: BaseScene<AuthResult> { VerifyScene<PA>() }
   var chooseOrgScene: BaseScene<[OrganizationAuth]> { ChooseOrgScene<PA>() }
   //
   var main: BaseScene<Void> { MainScene<PA>() }
   //
   var myProfile: BaseScene<Void> { MyProfileScene<PA>() }
   var profile: BaseScene<ProfileID> { ProfileScene<PA>() }
//   var diagramProfile: BaseScene<ProfileID> { MyProfileScene<PA>() }
   var userStatusSelector: BaseScene<Void> { UserStatusSelectorScene<PA>() }
   //
   var transactDetails: BaseScene<TransactDetailsSceneInput> { TransactDetailsScene<PA>() }
   var sentTransactDetails: BaseScene<Transaction> { SentTransactDetailsScene<PA>() }
   //
   var challengeDetails: BaseScene<ChallengeDetailsInput> { ChallengeDetailsScene<PA>() }
   var challengeCreate: BaseScene<Void> { ChallengeCreateScene<PA>() }
   var challengeSendResult: BaseScene<Int> { ChallengeResultScene<PA>() }
   var challengeResCancel: BaseScene<Int> { ChallengeResCancelScene<PA>() }
   var challengeReportDetail: BaseScene<Int> { ChallReportDetailsScene<PA>() }
   //
   var notifications: BaseScene<Void> { NotificationsScene<PA>() }
   //
   var settings: BaseScene<UserData> { SettingsScene<PA>() }
   //
   var imageViewer: BaseScene<String> { ImageViewerScene<PA>() }
   //
   var playground: BaseScene<Void> { PlaygroundScene<PA>() }
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
