//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import PromiseKit
import RealmSwift
import SwiftUI
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
nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
PlaygroundPage.current.liveView = nc

enum Asset: AssetProtocol {
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

final class MainScene<Asset: AssetProtocol>: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Promise<UserData>
> {
    // MARK: - Balance View Model

    private lazy var balanceViewModel = BalanceViewModel<Asset>()
    private lazy var transactViewModel = TransactViewModel<Asset>() // TODO:
    private lazy var historyViewModel = ImageViewModel() // TODO:

    private lazy var balanceButton = Design.button.tabBar
        .set(.title("Баланс"))
        .set(.image(icon.make(\.coinLine)))
        .onEvent(\.didTap) { [weak self] in
            self?.presentModel(self?.balanceViewModel)
        }

    private lazy var transactButton = Design.button.tabBar
        .set(.title("Новый перевод"))
        .set(.image(icon.make(\.upload2Fill)))
        .onEvent(\.didTap) { [weak self] in
            self?.presentModel(self?.transactViewModel)
        }

    private lazy var historyButton = Design.button.tabBar
        .set(.title("История"))
        .set(.image(icon.make(\.historyLine)))
        .onEvent(\.didTap) { [weak self] in
            self?.presentModel(self?.historyViewModel)
        }

    // MARK: - Side bar

    private lazy var sideBarModel = SideBarModel<Design>()

    private lazy var menuButton = BarButtonModel()
        .sendEvent(\.initWithImage, Design.icon.make(\.sideMenu))

    override func start() {
        print("LKDFJAHSLKFJLKSAFJLKASJLKFJ LAKS FJLKASJ FLAKJSFLKJF ")
        presentModel(balanceViewModel)

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

        menuButton
            .onEvent(\.initiated) { item in
                weakSelf?.vcModel?.sendEvent(\.setLeftBarItems, [item])
            }
            .onEvent(\.didTap) {
                guard let self = weakSelf else { return }

                self.sideBarModel.sendEvent(\.presentOnScene, self.mainViewModel.view)
            }
    }
}

extension MainScene {
    private func presentModel(_ model: UIViewModel?) {
        guard let model = model else { return }

        mainViewModel.stackModel
            .set(.models([
                model
            ]))
    }
}

struct BalanceViewEvent: InitProtocol {}

final class BalanceViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
    Communicable,
    Stateable,
    Assetable
{
    var text: Asset.Text = .init()
    var icon: Asset.Design.Icon = .init()

    var eventsStore: BalanceViewEvent = .init()

    // MARK: - Frame Cells

    private lazy var digitalThanksTitle = Design.label.headline4
        .set(.text(text.title.make(\.digitalThanks)))
        .set(.numberOfLines(1))
        .set(.alignment(.left))
        .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

    private lazy var frameModel = LabelIconHorizontalModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .set(.text(text.title.make(\.selectPeriod)))
        .set(.image(Design.icon.make(\.calendarLine)))

    private lazy var frameModel2 = DoubleLabelPairModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))

    private lazy var leftFrameCell = FrameCellModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.header(text.title.make(\.myAccount)))

    private lazy var rightFrameCell = FrameCellModel<Design>()
        .set(.header(text.title.make(\.leftToSend)))
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

    private lazy var menuButton = BarButtonModel()
        .sendEvent(\.initWithImage, Design.icon.make(\.sideMenu))

    // MARK: - Services

    private lazy var userProfileApiModel = GetProfileApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var balanceApiModel = GetBalanceApiModel(apiEngine: Asset.service.apiEngine)

    private var balance: Balance?

    override func start() {
        set(.axis(.vertical))
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.models([
            digitalThanksTitle,
            frameModel,
            Spacer(size: 20),
            frameCellStackModel,
            Spacer(size: 8),
            frameModel2,
            Spacer()
        ]))

        weak var weakSelf = self

        guard
            let realm = try? Realm(),
            let token = realm.objects(Token.self).first
        else {
            return
        }

        print(token.token)
        balanceApiModel
            .onEvent(\.success) { balance in
                weakSelf?.setBalance(balance)
            }
            .onEvent(\.error) {
                print($0)
            }
            .sendEvent(\.request, TokenRequest(token: token.token))
    }
}

extension BalanceViewModel {
    private func setBalance(_ balance: Balance) {
        setIncome(balance.income)
        setDistr(balance.distr)

        let frozenSum = balance.income.frozen + balance.distr.frozen
        let cancelledSum = balance.income.cancelled + balance.distr.cancelled

        frameModel2
            .set(.leftPair(text1: "\(text.title.make(\.onAgreement)): ",
                           text2: "\(frozenSum)"))
            .set(.rightPair(text1: "\(text.title.make(\.canceled)): ",
                            text2: "\(cancelledSum)"))
    }

    private func setIncome(_ income: Income) {
        leftFrameCell
            .set(.text(String(income.amount)))
            .set(.caption("\(text.title.make(\.sended)): \(income.sended)"))
    }

    private func setDistr(_ distr: Distr) {
        rightFrameCell
            .set(.text(String(distr.amount)))
            .set(.caption("\(text.title.make(\.sended)): \(distr.sended)"))
    }
}

final class TransactViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
    Assetable,
    Stateable
{
    var text: Asset.Text = .init() // Move to self.design.text......
    var icon: Asset.Design.Icon = .init()

    private lazy var digitalThanksTitle = Design.label.headline4
        .set(.text(text.title.make(\.digitalThanks)))
        .set(.numberOfLines(1))
        .set(.alignment(.left))
        .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

    private lazy var selectPeriodViewModel = LabelIconHorizontalModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .set(.text(text.title.make(\.selectPeriod)))
        .set(.image(Design.icon.make(\.calendarLine)))
        .sendEvent(\.startTapRecognizer)

    private lazy var pickerModel = PickerViewModel()
       // .set(.height(100))

    override func start() {

        set(.axis(.vertical))
            .set(.distribution(.fill))
            .set(.alignment(.fill))
            .set(.models([
                digitalThanksTitle,
                selectPeriodViewModel,
                pickerModel,
                Spacer()
            ]))

        selectPeriodViewModel
            .onEvent(\.didTap) {
                print("selectPeriodViewModel")
            }
    }
}

enum ViewState {
    case backColor(UIColor)
    case cornerRadius(CGFloat)
    case borderWidth(CGFloat)
    case borderColor(UIColor)
    case height(CGFloat)
}

// MARK: -  Stateable extensions

extension Stateable where Self: ViewModelProtocol, View: UIView {
    func applyState(_ state: ViewState) {
        switch state {
        case .backColor(let value):
            view.backgroundColor = value
        case .height(let value):
            view.addAnchors.constHeight(value)
        case .cornerRadius(let value):
            view.layer.cornerRadius = value
        case .borderColor(let value):
            view.layer.borderColor = value.cgColor
        case .borderWidth(let value):
            view.layer.borderWidth = value
        }
    }
}

final class PickerViewModel: BaseViewModel<UIPickerView> {
    override func start() {
        set(.height(200))
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .lightGray

      //  view.addAnchors.constWidth(200)

//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        set(.height(100))
    }
}

extension PickerViewModel: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "First \(row)"
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}

extension PickerViewModel: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
}

extension PickerViewModel: Stateable {
    typealias State = ViewState
}

// MARK: - Todo

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
