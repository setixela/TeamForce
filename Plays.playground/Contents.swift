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

Asset.router?
    .onEvent(\.push) { vc in
        //     vc.view
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
//    }
