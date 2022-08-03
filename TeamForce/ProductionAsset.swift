//
//  Asset.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

enum ProductionAsset: AssetProtocol {
   typealias Text = Texts
   typealias Design = DesignSystem
   typealias Service = ProductionService
   typealias Scene = Scenes

   static var router: Router<Scene>? = Router<Scene>()
   static var apiUseCase: ApiUseCase {
      .init(
         safeStringStorage: StringStorageWorker(engine: service.safeStringStorage),
         userProfileApiModel: ProfileApiWorker(apiEngine: service.apiEngine),
         loginApiModel: AuthApiWorker(apiEngine: service.apiEngine),
         logoutApiModel: LogoutApiWorker(apiEngine: service.apiEngine),
         balanceApiModel: GetBalanceApiWorker(apiEngine: service.apiEngine),
         searchUserApiWorker: SearchUserApiWorker(apiEngine: service.apiEngine),
         sendCoinApiWorker: SendCoinApiWorker(apiEngine: service.apiEngine)
      )
   }
}

struct Scenes: ScenesProtocol {
   var digitalThanks: SceneModelProtocol { DigitalThanksScene<ProductionAsset>() }
   var login: SceneModelProtocol { LoginScene<ProductionAsset>() }
   var verifyCode: SceneModelProtocol { VerifyCodeScene<ProductionAsset>() }
   var loginSuccess: SceneModelProtocol { LoginSuccessScene<ProductionAsset>() }
   var register: SceneModelProtocol { RegisterScene<ProductionAsset>() }
   var main: SceneModelProtocol { MainScene<ProductionAsset>() }
   var profile: SceneModelProtocol { ProfileViewModel<ProductionAsset>() }
}

struct ProductionService: ServiceProtocol {
   var apiEngine: ApiEngineProtocol { ApiEngine() }
   var safeStringStorage: StringStorageProtocol { KeyChainStore() }
}
