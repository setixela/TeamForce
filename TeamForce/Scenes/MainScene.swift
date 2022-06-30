//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import PromiseKit
import RealmSwift
import UIKit

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

    private lazy var frameModel2 = LabelIconHorizontalModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .sendEvent(\.setText, "Выберите период")
        .sendEvent(\.setImage, icon.make(\.calendarLine))

    private lazy var leftFrameCell = FrameCellModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
    private lazy var rightFrameCell = FrameCellModel<Design>()
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

        guard
            let realm = try? Realm(),
            let token = realm.object(ofType: Token.self,
                                     forPrimaryKey: Token.primaryKey()),
            let result = weakSelf?.inputValue?.result
        else {
            return
        }

        switch result {
        case .fulfilled(let user):
            print(user)
        default:
            print("REJECTED:\n")


        }

        balanceApiModel
            .onEvent(\.response) { balance in
                print(balance)
            }
            .sendEvent(\.request, TokenRequest(token: token.token))
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
        .set(.text("Мой счет"))
    private lazy var textLabel = Design.label.counter
        .set(.text("2300"))
    private lazy var captionLabel = Design.label.caption
        .set(.text("Распределено: 340"))

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
            weakSelf?.headerLabel.set(.text($0))
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

public protocol TargetViewProtocol: UIView {
    associatedtype TargetView: UIView

    var targetView: TargetView { get }
}

final class TargetViewModel<TVM: ViewModelProtocol>: BaseViewModel<TVM.View> {
    lazy var targetModel = TVM()

    override func start() {}
}

final class TargetView<View: UIView>: UIView, TargetViewProtocol {
    lazy var targetView: View = {
        let view = View()
        self.addSubview(view)
        return view
    }()

    typealias TargetView = View
}
