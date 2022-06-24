//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import PromiseKit
@testable import TeamForce
import UIKit

func example(_ name: String = "", action: () -> Void) {
    print("\n--- Example \(name):")
    action()
}

let nc = UINavigationController()
nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
PlaygroundPage.current.liveView = nc

enum Asset: AssetProtocol {

    typealias Design = DesignSystem

    static var router: Router<Scene>? = Router<Scene>()

    struct Scene: InitProtocol {
        var digitalThanks: SceneModelProtocol { DigitalThanksScene() }
        var login: SceneModelProtocol { LoginScene() }
        var verifyCode: SceneModelProtocol { VerifyCodeScene() }
        var loginSuccess: SceneModelProtocol { LoginSuccessScene() }
        var register: SceneModelProtocol { RegisterScene() }
        var main: SceneModelProtocol { MainScene() }
    }

    struct Service: InitProtocol {}
}


Asset.router?
    .onEvent(\.push) { vc in
        nc.pushViewController(vc, animated: true)
    }
    .onEvent(\.pop) {
        nc.popViewController(animated: true)
    }
    .onEvent(\.popToRoot) {
        nc.popToRootViewController(animated: true)
    }
    .route(\.main, navType: .push, payload: ())
//    .route(\.loginSuccess, navType: .push, payload: ())

let api = TeamForceApi(engine: ApiEngine())

// api
//    .auth(loginName: "setixela")
//    .done { result in
//        api
//            .verify(authResult: result)
//            .done { result in
//                print("Verify result: ", result)
//            }
//            .catch { error in
//                print("Verify error: ", error)
//            }
//    }
//    .catch { error in
//        print("Auth error: ", error)
//    }

final class MainScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var balanceButton = Design.button.default.setup {
        $0.set(\.title, "Баланс")
    }
    private lazy var transactButton = Design.button.default.setup {
        $0.set(\.title, "Новый перевод")
    }
    private lazy var historyButton = Design.button.default.setup {
        $0.set(\.title, "История")
    }

    override func start() {
        mainViewModel.bottomModel.updateState
            .set(\.axis, .horizontal)
            .set(\.padding, .zero)

        mainViewModel.bottomModel.sendEvent(\.addModels, [
            balanceButton,
            transactButton,
            historyButton
        ])
    }
}

