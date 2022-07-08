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
}

struct Scenes: ScenesProtocol {
    var digitalThanks: SceneModelProtocol { DigitalThanksScene<ProductionAsset>() }
    var login: SceneModelProtocol { LoginScene<ProductionAsset>() }
    var verifyCode: SceneModelProtocol { VerifyCodeScene<ProductionAsset>() }
    var loginSuccess: SceneModelProtocol { LoginSuccessScene<ProductionAsset>() }
    var register: SceneModelProtocol { RegisterScene<ProductionAsset>() }
    var main: SceneModelProtocol { MainScene<ProductionAsset>() }
}

struct ProductionService: ServiceProtocol {
    var apiEngine: ApiEngineProtocol { ApiEngine() }
    var safeStringStorage: StringStorage { KeyChainStore() }
}

