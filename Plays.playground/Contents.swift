//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import PromiseKit
import RealmSwift
@testable import TeamForce
import UIKit

func example(_ name: String = "", action: () -> Void) {
    print("\n--- Example \(name):")
    action()
}

let relm = try? Realm()
let newToken = Token()
newToken.token = "2f184dab87c86fbd981315ea06f4fd1eeb95bb2d"
try? relm?.write {
    relm?.add(newToken, update: .all)
}

let nc = UINavigationController()
nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 800)
PlaygroundPage.current.liveView = nc

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
        var main: SceneModelProtocol { MainScene() }
    }

    struct Service: InitProtocol {}
}

Asset.router?
    .onEvent(\.push) { vc in
        vc.view
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

// let api = TeamForceApi(engine: ApiEngine())

// import RealmSwift

final class MainScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Promise<UserData>
> {
    //
    private lazy var digitalThanksTitle = Design.label.headline4
        .set(.text(text.title.make(\.digitalThanks)))
        .set(.numberOfLines(1))
        .set(.alignment(.left))
        .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

    private lazy var balanceButton = Design.button.tabBar
        .set(.title("Баланс"))
        .set(.image(icon.make(\.coinLine)))

    private lazy var transactButton = Design.button.tabBar
        .set(.title("Новый перевод"))
        .set(.image(icon.make(\.upload2Fill)))

    private lazy var historyButton = Design.button.tabBar
        .set(.title("История"))
        .set(.image(icon.make(\.historyLine)))

    // MARK: - Frame Cells

    private lazy var frameModel = LabelIconHorizontalModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .sendEvent(\.setText, "Выберите период")
        .sendEvent(\.setImage, icon.make(\.calendarLine))

    private lazy var frameModel2 = DoubleLabelPairModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
//        .sendEvent(\.setLeftText, "На согласовании: ")

    private lazy var leftFrameCell = FrameCellModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .sendEvent(\.setHeader, "Мой счет")
    private lazy var rightFrameCell = FrameCellModel<Design>()
        .sendEvent(\.setHeader, "Осталось раздать")
        .set(.borderWidth(1))
        .set(.borderColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))

    private lazy var frameCellStackModel = StackModel()
        .set(.axis(.horizontal))
        .set(.distribution(.fillEqually))
        .set(.alignment(.center))
        .set(.spacing(8))
        .set(.models([
            leftFrameCell,
            rightFrameCell
        ]))

    // MARK: - Services

    private lazy var userProfileApiModel = GetProfileApiModel()
    private lazy var balanceApiModel = GetBalanceApiModel()

    private var balance: Balance?

    override func start() {
        mainViewModel.stackModel
            .set(.models([
                digitalThanksTitle,
                frameModel,
                Spacer(size: 20),
                frameCellStackModel,
                Spacer(size: 8),
                frameModel2,
                Spacer()
            ]))

        mainViewModel.bottomModel
            .set(.axis(.horizontal))
            .set(.padding(.zero))
            .set(.spacing(0))
            .set(.backColor(.black))

        mainViewModel.bottomModel
            .set(.models([
                balanceButton,
                transactButton,
                historyButton
            ]))

        weak var weakSelf = self
//        let realm = try? Realm()
//        print(realm)

        guard
            let realm = try? Realm(),
            let token = realm.objects(Token.self).first
        else {
            return
        }

        let tokens = realm.objects(Token.self)

        print(token.token)
        balanceApiModel
            .onEvent(\.response) { balance in
                weakSelf?.setBalance(balance)
            }
            .onEvent(\.error) {
                print($0)
            }
            .sendEvent(\.request, TokenRequest(token: token.token))

//        guard
//            let result = weakSelf?.inputValue?.result
//        else {
//            return
//        }
//        switch result {
//        case .fulfilled(let user):
//            print(user)
//        default:
//            print("REJECTED:\n")
//
//
//        }
    }

    private func setBalance(_ balance: Balance) {
        setIncome(balance.income)
        setDistr(balance.distr)

        let frozenSum = balance.income.frozen + balance.distr.frozen
        let cancelledSum = balance.income.cancelled + balance.distr.cancelled
        frameModel2.doubleLabelLeft
            .sendEvent(\.setLeftText, "На согласовании: ")
            .sendEvent(\.setRightText, "\(frozenSum)")
        frameModel2.doubleLabelRight
            .sendEvent(\.setLeftText, "Аннулировано: ")
            .sendEvent(\.setRightText, "\(cancelledSum)")
    }

    private func setIncome(_ income: Income) {
        leftFrameCell
            .sendEvent(\.setText, String(income.amount))
            .sendEvent(\.setCaption, "Распределено: \(income.sended)")
    }

    private func setDistr(_ distr: Distr) {
        rightFrameCell
            .sendEvent(\.setText, String(distr.amount))
            .sendEvent(\.setCaption, "Распределено: \(distr.sended)")
    }
}

struct FrameCellEvent: InitProtocol {
    var setHeader: Event<String>?
    var setText: Event<String>?
    var setCaption: Event<String>?
}

protocol Designable {
    associatedtype Design: DesignSystemProtocol
}

final class FrameCellModel<Design: DesignSystemProtocol>: BaseViewModel<UIStackView> {
    var eventsStore: FrameCellEvent = .init()

    private lazy var headerLabel = Design.label.body2
    private lazy var textLabel = Design.label.counter
    private lazy var captionLabel = Design.label.caption

    required init() {
        super.init()
    }

    override func start() {
        print("Type", type(of: headerLabel))
        set(.axis(.vertical))
            .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
            .set(.cornerRadius(Design.Parameters.cornerRadius))
            .set(.models([
                headerLabel,
                textLabel,
                captionLabel
            ]))

        weak var weakSelf = self
        onEvent(\.setHeader) {
            weakSelf?.headerLabel.set(.text($0))
        }
        .onEvent(\.setText) {
            weakSelf?.textLabel.set(.text($0))
        }
        .onEvent(\.setCaption) {
            weakSelf?.captionLabel.set(.text($0))
        }
    }
}

extension FrameCellModel: Communicable, Stateable, Designable {}

struct LabelIconEvent: InitProtocol {
    var setText: Event<String>?
    var setImage: Event<UIImage>?
}

final class LabelIconHorizontalModel<Design: DesignSystemProtocol>: BaseViewModel<UIStackView>,
    Communicable,
    Stateable,
    Designable
{
    var eventsStore: LabelIconEvent = .init()

    lazy var label = Design.label.body2
    lazy var icon = ImageViewModel()

    required init() {
        super.init()
    }

    override func start() {
        set(.axis(.horizontal))
            .set(.cornerRadius(Design.Parameters.cornerRadius))
            .set(.distribution(.fill))
            .set(.alignment(.fill))
            .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
            .set(.models([
                label,
                Spacer(),
                icon
            ]))

        weak var weakSelf = self
        onEvent(\.setText) {
            weakSelf?.label.set(.text($0))
        }
        .onEvent(\.setImage) {
            weakSelf?.icon.set(.image($0))
        }
    }
}

struct DoubleLabelEvent: InitProtocol {
    var setLeftText: Event<String>?
    var setRightText: Event<String>?
}

final class DoubleLabelPairModel<Design: DesignSystemProtocol>: BaseViewModel<UIStackView>,
    Stateable,
    Designable
{
    lazy var doubleLabelLeft = DoubleLabelModel<Design>()
    lazy var doubleLabelRight = DoubleLabelModel<Design>()

    override func start() {
        set(.axis(.horizontal))
            .set(.cornerRadius(Design.Parameters.cornerRadius))
            .set(.distribution(.fillProportionally))
            .set(.alignment(.fill))
            // .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
            .set(.models([
                doubleLabelLeft,
                doubleLabelRight
            ]))
    }
}

final class DoubleLabelModel<Design: DesignSystemProtocol>: BaseViewModel<UIStackView>,
    Communicable,
    Stateable,
    Designable
{
    var eventsStore: DoubleLabelEvent = .init()

    lazy var labelLeft = Design.label.body2
    lazy var labelRight = Design.label.body2

    override func start() {
        set(.axis(.horizontal))
            .set(.cornerRadius(Design.Parameters.cornerRadius))
            .set(.distribution(.fill))
            .set(.alignment(.fill))
            .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
            .set(.models([
                labelLeft,
                labelRight,
                Spacer()
            ]))

        weak var weakSelf = self
        onEvent(\.setLeftText) {
            weakSelf?.labelLeft.set(.text($0))
        }
        .onEvent(\.setRightText) {
            weakSelf?.labelRight.set(.text($0))
        }
    }
}

// public protocol TargetViewProtocol: UIView {
//    associatedtype TargetView: UIView
//
//    var targetView: TargetView { get }
// }
//
// final class TargetViewModel<TVM: ViewModelProtocol>: BaseViewModel<TVM.View> {
//    lazy var targetModel = TVM()
//
//    override func start() {}
// }
//
// final class TargetView<View: UIView>: UIView, TargetViewProtocol {
//    lazy var targetView: View = {
//        let view = View()
//        self.addSubview(view)
//        return view
//    }()
//
//    typealias TargetView = View
// }
