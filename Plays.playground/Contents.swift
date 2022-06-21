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
        nc.pushViewController(vc, animated: true)
    }
    .onEvent(\.pop) {
        nc.popViewController(animated: true)
    }
    .onEvent(\.popToRoot) {
        nc.popToRootViewController(animated: true)
    }
    .route(\.digitalThanks, navType: .push, payload: ())

///

let api = TeamForceApi(engine: ApiEngine())

enum Asset: AssetProtocol {
    static var router: Router<Scene>? = Router<Scene>()

    struct Scene: InitProtocol {
        var digitalThanks: SceneModelProtocol { DigitalThanksScene() }
    }

    struct Service: InitProtocol {}
}

// MARK: -

final class DigitalThanksScene: BaseSceneModel<DefaultVCModel, StackModel, Asset, Void> {
    private lazy var headerModel: LabelModel = {
        let labelModel = LabelModel()
        // labelModel.sendEvent(\.setText, payload: "Цифровое спасибо")

       // labelModel.start()

        labelModel.setup()
            .setNumberOfLines(2)
            .setPadding(UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
            .setText("Цифровое спасибо")
            .setFont(UIFont.systemFont(ofSize: 48, weight: .regular))
            .setAlignment(.center)
            .setColor(.black)

        return labelModel
    }()

    private let textModel = TextFieldModel()

    override func start() {
        weak var weakSelf = self


        vcModel?
            .onEvent(\.viewDidLoad) {
                guard let self = weakSelf else { return }

                self.mainViewModel.setup()
                    .setAxis(.vertical)
                    .setSpacing(0)
                    .setAlignment(.fill)
                    .setDistribution(.fill)

                self.textModel
                    .onEvent(\.didEditingChanged) { text in
                        print(text)
                    }
                

                print("addViewModels")
                self.mainViewModel.sendEvent(\.addViewModels, payload: [
                    SpacerModel(size: 100),
                    self.headerModel,
                    self.textModel,
                    SpacerModel()
                ])
                print("end addViewModels")
            }
    }
}

final class TextFieldModel: BaseViewModel<UITextField> {
    var eventsStore: Events = .init()

    override func start() {
//        view.backgroundColor = .white
//        print(view)
        view.addAnchors.constHeight(60)
        view.backgroundColor = .lightGray
        view.delegate = self
        view.addTarget(self, action: #selector(changValue), for: .editingChanged)
    }

    @objc func changValue() {
        guard let text = view.text else { return }

        sendEvent(\.didEditingChanged, payload: text)
    }
}

extension TextFieldModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.becomeFirstResponder()
    }
}

extension TextFieldModel: Communicable {
    struct Events: InitProtocol {
        var didEditingChanged: Event<String>?
    }
}

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

final class SpacerModel: BaseViewModel<SpacerView> {
    convenience init(size: CGFloat = .zero) {
        self.init(autostart: true)

        if size != 0 {
            view.addAnchors
                .constWidth(size)
                .constHeight(size)
        }
    }

    override func start() {}
}

final class SpacerView: UIView {
    convenience init(size: CGFloat = .zero) {
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        if size != 0 {
            addAnchors
                .constWidth(size)
                .constHeight(size)
        }
        backgroundColor = .none
        isAccessibilityElement = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init() {
        self.init(size: .zero)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}

protocol MakeProtocol: AnyObject, InitProtocol {
    static func make() -> Self
}

extension MakeProtocol {
    static func make() -> Self {
        Self()
    }
}
