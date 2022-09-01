//
//  Asset.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks

enum ProductionAsset: AssetProtocol {
   typealias Router = MainRouter<Scene>
   typealias Text = TextBuilder
   typealias Design = DesignSystem
   typealias Service = ProductionService
   typealias Scene = Scenes

   static var router: MainRouter<Scene>? = MainRouter<Scene>()
}

struct Scenes: ScenesProtocol {
   var playground: SceneModelProtocol { PlaygroundScene<ProductionAsset>()}
   //
   var digitalThanks: SceneModelProtocol { DigitalThanksScene<ProductionAsset>() }
   var login: SceneModelProtocol { LoginScene<ProductionAsset>() }
   //
   var main: SceneModelProtocol { MainScene<ProductionAsset>() }
   //
   var profile: SceneModelProtocol { ProfileScene<ProductionAsset>() }
   var transactionDetail: SceneModelProtocol { TransactDeatilViewModel<ProductionAsset>() }
   var profileEdit: SceneModelProtocol { ProfileEditScene<ProductionAsset>() }

   // camera
   var imagePicker: SceneModelProtocol { ImagePickerScene<ProductionAsset>() }
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
   typealias Router = MainRouter<Scene>
   typealias Text = TextBuilder
   typealias Design = DesignSystem
   typealias Service = MockService
   typealias Scene = Scenes

   static var router: MainRouter<Scene>? = MainRouter<Scene>()
   static var globalRetainer: Retainer? = Retainer()
}
