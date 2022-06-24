//
//  Asset.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

enum Asset: AssetProtocol {
    
    typealias Text = Texts
    typealias Design = DesignSystem

    static var router: Router<Scene>? = Router<Scene>()

    struct Scene: InitProtocol {
        var digitalThanks: SceneModelProtocol { DigitalThanksScene() }
        var login: SceneModelProtocol { LoginScene() }
        var verifyCode: SceneModelProtocol { VerifyCodeScene() }
        var loginSuccess: SceneModelProtocol { LoginSuccessScene() }
        var register: SceneModelProtocol { RegisterScene() }
      //  var main: SceneModelProtocol { MainScene() }
    }

    struct Service: InitProtocol {}
}
