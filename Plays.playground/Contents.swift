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

// enum Asset: AssetProtocol {
//    typealias Text = Texts
//
//    typealias Design = DesignSystem
//
//    static var router: Router<Scene>? = Router<Scene>()
//
//    struct Scene: InitProtocol {
//        var digitalThanks: SceneModelProtocol { DigitalThanksScene() }
//        var login: SceneModelProtocol { LoginScene() }
//        var verifyCode: SceneModelProtocol { VerifyCodeScene() }
//        var loginSuccess: SceneModelProtocol { LoginSuccessScene() }
//        var register: SceneModelProtocol { RegisterScene() }
//        var main: SceneModelProtocol { MainScene() }
//    }
//
//    struct Service: InitProtocol {}
// }

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
    .route(\.digitalThanks, navType: .push, payload: ())
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
//

//struct NetworkEvent<Request, Result, Error>: InitProtocol {
//    var sendRequest: Event<Request>?
//    var responseResult: Event<Result>?
//    var responseError: Event<Error>?
//}
//
//final class AuthApiModel: BaseModel, Communicable {
//    private let apiEngine = ApiEngine()
//
//    var eventsStore: NetworkEvent<String, AuthResult, ApiEngineError> = .init()
//
//    override func start() {
//        onEvent(\.sendRequest) { [weak self] loginName in
//            self?.apiEngine
//                .process(endpoint: TeamForceEndpoints.AuthEndpoint(
//                    body: ["type": "authorize",
//                           "login": loginName]
//                ))
//                .done { result in
//                    guard
//                        let xId = result.response?.headerValueFor("X-ID"),
//                        let xCode = result.response?.headerValueFor("X-Code")
//                    else {
//                        self?.sendEvent(\.responseError, .unknown)
//                        return
//                    }
//
//                    self?.sendEvent(\.responseResult, AuthResult(xId: xId, xCode: xCode))
//                }
//                .catch { error in
//                    self?.sendEvent(\.responseError, .error(error))
//                }
//        }
//    }
//}
