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

///

let api = TeamForceApi(engine: ApiEngine())

enum Asset: AssetProtocol {
    static var router: Router<Scene>? = Router<Scene>()

    struct Scene: InitProtocol {
        var digitalThanks: SceneModelProtocol { DigitalThanksScene() }
        var login: SceneModelProtocol { LoginScene() }
        var verifyCode: SceneModelProtocol { VerifyCodeScene() }
        var loginSuccess: SceneModelProtocol { LoginSuccessScene() }
        var register: SceneModelProtocol { RegisterScene() }
    }

    struct Service: InitProtocol {}
}

// MARK: - DigitalThanksScene

final class DigitalThanksScene: BaseSceneModel<
    DefaultVCModel,
    StackModel,
    Asset,
    Void
> {
    private lazy var headerModel = DesignSystem.label.headline3
        .setup {
            $0
                .set(\.numberOfLines, 2)
                .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
                .set(\.text, "Цифровое спасибо")
                .set(\.alignment, .center)
        }

    private lazy var enterButton = DesignSystem.button.default
        .setup {
            $0.set(\.title, "ВХОД")
        }

    private lazy var registerButton = DesignSystem.button.transparent
        .setup {
            $0.set(\.title, "РЕГИСТРАЦИЯ")
        }

    override func start() {
        weak var weakSelf = self

        enterButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.login, navType: .push)
                print("Did tap")
            }

        registerButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.register, navType: .push)
                print("Did tap")
            }

        vcModel?
            .onEvent(\.viewDidLoad) {
                guard let self = weakSelf else { return }

                self.setupMainViewModel()
                self.presentModels()
            }
    }

    private func setupMainViewModel() {
        mainViewModel.setup(DesignSystem.Setup.mainView.default)
    }

    private func presentModels() {
        mainViewModel.sendEvent(\.addViewModels, payload: [
            Spacer(size: 100),
            headerModel,
            enterButton,
            Spacer(size: 16),
            registerButton,
            Spacer()
        ])
    }
}

// MARK: - RegisterScene

final class RegisterScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var headerModel = DesignSystem.label.headline4.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
            .set(\.text, "Регистрация")
    }

    private lazy var subtitleModel = DesignSystem.label.subtitle.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
            .set(\.text, "1. Введите имя пользователя telegram или идентификатор")
            .set(\.numberOfLines, 2)
    }

    private lazy var nextButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.inactive)
        .setup {
            $0.set(\.title, "ДАЛЕЕ")
        }

    private lazy var textFieldModel = TextFieldModel()

    private lazy var inputParser = TelegramNickCheckerModel()

    override func start() {
        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
                print("Did tap")
            }

        vcModel?
            .onEvent(\.viewDidLoad) {
                weakSelf?.setupLoginField()
                weakSelf?.presentModels()
            }
    }

    private func setupLoginField() {
        textFieldModel
            .onEvent(\.didEditingChanged) { [weak self] text in
                self?.inputParser.sendEvent(\.request, text)
            }
            .sendEvent(\.setPlaceholder, "@Имя пользователя")
        inputParser
            .onEvent(\.response) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.default)
            }
            .onEvent(\.error) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.inactive)
            }
    }

    private func presentModels() {
        mainViewModel
            .sendEvent(\.addViewModels, payload: [
                Spacer(size: 100),
                headerModel,
                subtitleModel,
                Spacer(size: 16),
                textFieldModel,
                Spacer()
            ])
            .sendEvent(\.addBottomPanelModel, payload: nextButton)
    }
}

// MARK: - LoginScene

final class LoginScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var headerModel = DesignSystem.label.headline4.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
            .set(\.text, "Вход")
    }

    private lazy var subtitleModel = DesignSystem.label.subtitle.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
            .set(\.text, "1. Для входа нажмите ”получить код”, или смените пользователя ")
            .set(\.numberOfLines, 2)
    }

    private lazy var nextButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.inactive)
        .setup {
            $0.set(\.title, "ПОЛУЧИТЬ КОД")
        }

    private lazy var changeUserButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.transparent)
        .setup {
            $0.set(\.title, "СМЕНИТЬ ПОЛЬЗОВАТЕЛЯ")
        }

    private lazy var textFieldModel = TextFieldModel()

    private lazy var inputParser = TelegramNickCheckerModel()

    override func start() {
        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.verifyCode, navType: .push)
                print("Did tap")
            }

        vcModel?
            .onEvent(\.viewDidLoad) {
                weakSelf?.setupLoginField()
                weakSelf?.presentModels()
            }
    }

    private func setupLoginField() {
        textFieldModel
            .onEvent(\.didEditingChanged) { [weak self] text in
                self?.inputParser.sendEvent(\.request, text)
            }
            .sendEvent(\.setPlaceholder, "@Имя пользователя")
        inputParser
            .onEvent(\.response) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.default)
            }
            .onEvent(\.error) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.inactive)
            }
    }

    private func presentModels() {
        mainViewModel
            .sendEvent(\.addViewModels, payload: [
                Spacer(size: 100),
                headerModel,
                subtitleModel,
                Spacer(size: 16),
                textFieldModel,
                Spacer()
            ])
            .sendEvent(\.addBottomPanelModel, payload: nextButton)
            .sendEvent(\.addBottomPanelModel, payload: changeUserButton)
    }
}

// MARK: - VerifyCodeScene

final class VerifyCodeScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var headerModel = DesignSystem.label.headline4.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
            .set(\.text, "Вход")
    }

    private lazy var subtitleModel = DesignSystem.label.subtitle.setup {
        $0
            .set(\.padding, UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0))
            .set(\.text, "2. Введите код")
            .set(\.numberOfLines, 2)
    }

    private lazy var nextButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.inactive)
        .setup {
            $0.set(\.title, "ВОЙТИ")
        }

    private lazy var textFieldModel = TextFieldModel()

    private lazy var inputParser = SmsCodeCheckerModel()

    override func start() {
        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
                Asset.router?.route(\.loginSuccess, navType: .push)
                print("Did tap")
            }

        vcModel?
            .onEvent(\.viewDidLoad) {
                weakSelf?.setupLoginField()
                weakSelf?.presentModels()
            }
    }

    private func setupLoginField() {
        textFieldModel
            .onEvent(\.didEditingChanged) { [weak self] text in
                self?.inputParser.sendEvent(\.request, text)
            }
            .sendEvent(\.setPlaceholder, "@Имя пользователя")
        inputParser
            .onEvent(\.response) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.default)
            }
            .onEvent(\.error) { [weak self] text in
                self?.textFieldModel.sendEvent(\.setText, text)
                self?.nextButton.setup(DesignSystem.Setup.buttonStateBuilder.inactive)
            }
    }

    private func presentModels() {
        mainViewModel
            .sendEvent(\.addViewModels, [
                Spacer(size: 100),
                headerModel,
                subtitleModel,
                Spacer(size: 16),
                textFieldModel,
                Spacer()
            ])
            .sendEvent(\.addBottomPanelModel, nextButton)
    }
}

// MARK: - LoginSuccessScene

final class LoginSuccessScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
> {
    private lazy var checkmarkIcon = ImageViewModel().setup {
        $0
            .set(\.size, .init(width: 48, height: 48))
            .set(\.image, Icons().make(\.checkCircle))
    }
    private lazy var headerModel = DesignSystem.label.headline4.setup {
        $0
            .set(\.alignment, .center)
            .set(\.numberOfLines, 2)
            .set(\.padding, UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0))
            .set(\.text, "Вы успешно зарегистрированы")
    }

    private lazy var nextButton = ButtonModel(state: DesignSystem.Setup.buttonStateBuilder.default)
        .setup {
            $0.set(\.title, "ВОЙТИ")
        }

    override func start() {

        mainViewModel.stackModel.updateState.set(\.alignment, .center)

        weak var weakSelf = self

        nextButton
            .onEvent(\.didTap) {
                print("Did tap")
            }

        vcModel?
            .onEvent(\.viewDidLoad) {
                weakSelf?.presentModels()
            }
    }

    private func presentModels() {
        mainViewModel
            .sendEvent(\.addViewModels, [
                Spacer(size: 100),
                checkmarkIcon,
                headerModel,
                Spacer(size: 16),
                Spacer()
            ])
            .sendEvent(\.addBottomPanelModel, nextButton)
    }
}

// MARK: - TextFieldModel

final class TextFieldModel: BaseViewModel<PaddingTextField> {
    var eventsStore: Events = .init()

    override func start() {
        print("\nStart TextFieldModel\n")
        view.addAnchors.constHeight(48)
        view.padding = .init(top: 16, left: 16, bottom: 16, right: 16)
        view.backgroundColor = .lightGray
        view.delegate = self
        view.addTarget(self, action: #selector(changValue), for: .editingChanged)

        weak var weakSelf = self

        onEvent(\.setText) { text in
            print("setText ", text)
            weakSelf?.view.text = text
        }
        .onEvent(\.setPlaceholder) { text in
            print("setPlaceholder ", text)
            weakSelf?.view.placeholder = text
        }
    }

    @objc func changValue() {
        guard let text = view.text else { return }

        sendEvent(\.didEditingChanged, text)
    }
}

extension TextFieldModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // view.becomeFirstResponder()
    }
}

extension TextFieldModel: Communicable {
    struct Events: InitProtocol {
        var didEditingChanged: Event<String>?
        var setText: Event<String>?
        var setPlaceholder: Event<String>?
    }
}

// MARK: - InputParserEvents

struct InputParserEvents: InitProtocol {
    var request: Event<String>?
    var response: Event<String>?
    var error: Event<String>?
}

// MARK: - TelegramNickCheckerModel

final class TelegramNickCheckerModel: BaseModel {
    var eventsStore: InputParserEvents = .init()

    override func start() {
        onEvent(\.request) { [weak self] text in

            var resultText = text == "" ? "@" : text
            if !resultText.hasPrefix("@") {
                resultText = "@" + resultText
            }
            if resultText.count > 3 {
                self?.sendEvent(\.response, resultText)
            } else {
                self?.sendEvent(\.error, resultText)
            }
        }
    }
}

extension TelegramNickCheckerModel: Communicable {}

// MARK: - SmsCodeCheckerModel

final class SmsCodeCheckerModel: BaseModel {
    var eventsStore: InputParserEvents = .init()

    override func start() {
        onEvent(\.request) { [weak self] text in

            if text.count == 4 {
                self?.sendEvent(\.response, text)
            } else {
                self?.sendEvent(\.error, text)
            }
        }
    }
}

extension SmsCodeCheckerModel: Communicable {}

// MARK: - BottomPanelViewModel

struct BottomPanelEvents: InitProtocol {
    var addModel: Event<UIViewModel>?
}

final class BottomPanelViewModel: BaseViewModel<UIStackView> {
    var eventsStore: BottomPanelEvents = .init()

    override func start() {
        configure()

        onEvent(\.addModel) { [weak self] in
            let view = $0.uiView
            self?.view.addArrangedSubview(view)
            self?.view.setNeedsLayout()
        }
    }

    private func configure() {
        setupView {
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .vertical
            $0.spacing = 12
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 48, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.backgroundColor = .lightGray
        }
    }
}

extension BottomPanelViewModel: Communicable {}

struct StackWithBottomPanelEvents: InitProtocol {
    var addViewModel: Event<UIViewModel>?
    var addViewModels: Event<[UIViewModel]>?
    var addBottomPanelModel: Event<UIViewModel>?
}

final class StackWithBottomPanelModel: BaseViewModel<UIStackView> {
    var eventsStore: StackWithBottomPanelEvents = .init()

    let stackModel = StackModel(state: DesignSystem.Setup.mainView.default)
    let bottomModel = BottomPanelViewModel()

    override func start() {
        configure()

        weak var wS = self

        onEvent(\.addViewModel) {
            wS?.stackModel.sendEvent(\.addViewModel, payload: $0)
        }
        .onEvent(\.addViewModels) {
            wS?.stackModel.sendEvent(\.addViewModels, payload: $0)
        }
        .onEvent(\.addBottomPanelModel) {
            wS?.bottomModel.sendEvent(\.addModel, payload: $0)
        }
    }

    private func configure() {
        setupView {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill

            $0.addArrangedSubview(stackModel.uiView)
            $0.addArrangedSubview(bottomModel.uiView)
        }
    }
}

extension StackWithBottomPanelModel: Communicable {}

final class ImageViewState: BaseClass, Setable {
    var image: UIImage?
    var size: CGSize?
}

final class ImageViewModel: BaseViewModel<UIImageView> {
    var state: ImageViewState = .init()

    override func start() {

    }

   // func appli
}

extension ImageViewModel: Stateable {

    func applyState() {
        view.image = state.image
        if let size = state.size {
            view.addAnchors
                .constWidth(size.width)
                .constHeight(size.height)
        }
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
