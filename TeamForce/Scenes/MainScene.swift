//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import PromiseKit
import UIKit

final class MainScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Promise<User>
> {
    //
    private lazy var digitalThanksTitle = Design.label.headline4
        .set(.text(text.title.make(\.digitalThanks)))
        .set(.numberOfLines(1))
        .set(.alignment(.left))

    private lazy var balanceButton = Design.button.tabBar
        .set(.title("Баланс"))
        .set(.image(icon.make(\.coinLine)))

    private lazy var transactButton = Design.button.tabBar
        .set(.title("Новый перевод"))
        .set(.image(icon.make(\.upload2Fill)))

    private lazy var historyButton = Design.button.tabBar
        .set(.title("История"))
        .set(.image(icon.make(\.historyLine)))

    private lazy var frameModel = StackModel()
        .set(.axis(.horizontal))
        .set(.distribution(.fill))
        .set(.alignment(.fill))
        .set(.backColor(.lightGray))
        .set(.height(48))

    override func start() {
        mainViewModel.stackModel.sendEvent(\.addViewModels, [
            digitalThanksTitle,
            frameModel,
            Spacer()
        ])

        mainViewModel.bottomModel
            .set(.axis(.horizontal))
            .set(.padding(.zero))
            .set(.spacing(0))
            .set(.backColor(.black))

        mainViewModel.bottomModel.sendEvent(\.addModels, [
            balanceButton,
            transactButton,
            historyButton
        ])

        weak var weakSelf = self
        vcModel?.onEvent(\.viewDidLoad) {
            guard let result = weakSelf?.inputValue?.result else { return }

            switch result {
            case .fulfilled(let user):
                print(user)
            case .rejected(let error):
                print("REJECTED:\n", error)
            }
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
