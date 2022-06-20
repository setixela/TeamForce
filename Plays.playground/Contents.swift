//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
@testable import TeamForce
import UIKit
import PromiseKit

class MyViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black

        view.addSubview(label)
        self.view = view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

let endpoint = TeamForceEndpoints.AuthEndpoint(body: ["type": "authorize",
                                                      "login": "1341062023"])
let api = TeamForceApi(engine: ApiEngine())


//api
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
