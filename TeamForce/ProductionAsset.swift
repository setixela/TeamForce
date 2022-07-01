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

    static var router: Router<Scene>? = Router<Scene>()

    struct Scene: InitProtocol {
        var digitalThanks: SceneModelProtocol { DigitalThanksScene() }
        var login: SceneModelProtocol { LoginScene() }
        var verifyCode: SceneModelProtocol { VerifyCodeScene() }
        var loginSuccess: SceneModelProtocol { LoginSuccessScene() }
        var register: SceneModelProtocol { RegisterScene() }
        var main: SceneModelProtocol { MainScene() }
    }
}

struct ProductionService: ServiceProtocol {
    var apiEngine: ApiEngineProtocol { ApiEngine() }
}
