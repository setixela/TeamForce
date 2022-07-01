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

    // MARK: - Side bar

    private lazy var sideBarModel = SideBarModel<Design>()

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

    private lazy var menuButton = BarButtonModel()
        .sendEvent(\.initWithImage, Design.Icon().make(\.historyLine))

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

        menuButton
            .onEvent(\.initiated) { [weak self] item in
                self?.vcModel?.sendEvent(\.setLeftBarItems, [item])
            }
            .onEvent(\.didTap) { [weak self] in
                guard let self = self else { return }
                self.sideBarModel.sendEvent(\.presentOnScene, self.mainViewModel.view)
            }

        weak var weakSelf = self
//        let realm = try? Realm()
//        print(realm)

       let realm = try? Realm()

        guard
        //    let realm = try? Realm(),
            let token = realm?.objects(Token.self).first
        else {
            return
        }

        print(token.token)
        balanceApiModel
            .onEvent(\.response) { balance in
                weakSelf?.setBalance(balance)
            }
            .onEvent(\.error) {
                print($0)
            }
            .sendEvent(\.request, TokenRequest(token: token.token))
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

struct BarButtonEvent: InitProtocol {
    var initWithImage: Event<UIImage>?
    var initiated: Event<UIBarButtonItem>?
    var didTap: Event<Void>?
}

final class BarButtonModel: BaseModel, Communicable {
    var eventsStore = BarButtonEvent()

    override func start() {
        onEvent(\.initWithImage) { [weak self] image in
            self?.startWithImage(image)
        }
    }

    private func startWithImage(_ image: UIImage) {
        let menuItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTap))
        sendEvent(\.initiated, menuItem)
    }

    @objc func didTap() {
        sendEvent(\.didTap)
    }
}

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

final class IconLabelHorizontalModel<Design: DesignSystemProtocol>: BaseViewModel<UIStackView>,
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
                icon,
                Spacer(size: 20),
                label,
                Spacer()
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

struct SideBarEvents: InitProtocol {
    var presentOnScene: Event<UIView>?
    var hide: Event<Void>?
}

final class SideBarModel<Design: DesignSystemProtocol>: BaseViewModel<UIStackView>,
    Communicable, Stateable, Designable
{
    var eventsStore: SideBarEvents = .init()

    private var isPresented = false

    private lazy var item1 = IconLabelHorizontalModel<Design>()
        .sendEvent(\.setText, "Баланс")
        .sendEvent(\.setImage, Design.icon.make(\.coinLine))
    private lazy var item2 = IconLabelHorizontalModel<Design>()
        .sendEvent(\.setText, "Баланс")
        .sendEvent(\.setImage, Design.icon.make(\.upload2Fill))
    private lazy var item3 = IconLabelHorizontalModel<Design>()
        .sendEvent(\.setText, "Баланс")
        .sendEvent(\.setImage, Design.icon.make(\.historyLine))

    override func start() {
        view.backgroundColor = .white
        set(.axis(.vertical))
            .set(.distribution(.fill))
            .set(.alignment(.leading))
            .set(.padding(.init(top: 12, left: 16, bottom: 12, right: 16)))
            .set(.models([
                item1,
                item2,
                item3,
                Spacer()
            ]))

        onEvent(\.presentOnScene) { [weak self] baseView in
            guard let self = self else { return }

            guard self.isPresented == false else {
                self.sendEvent(\.hide)
                return
            }

            print("\nSHOW\n")

            let size = baseView.frame.size
            let origin = baseView.frame.origin
            self.view.frame.size = CGSize(width: size.width * 0.8, height: size.height)
            self.view.frame.origin = CGPoint(x: -size.width, y: origin.y)
            baseView.addSubview(self.view)
            self.isPresented = true
            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin = origin
            }
        }
        .onEvent(\.hide) { [weak self] in
            guard let self = self else { return }
//            let size = baseView.frame.size
//            let origin = baseView.frame.origin
//            self?.view.frame.size = size
//            self?.view.frame.origin = CGPoint(x: -size.width, y: origin.y)
            print("\nHIDE\n")
            self.isPresented = false

            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin = CGPoint(x: -self.view.frame.size.width, y: 0)
            } completion: { _ in
                self.view.removeFromSuperview()
            }
        }
    }
}
