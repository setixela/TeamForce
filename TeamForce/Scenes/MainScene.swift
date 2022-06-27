//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import UIKit

final class MainScene: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
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

    override func start() {
        mainViewModel.stackModel.sendEvent(\.addViewModels, [
            digitalThanksTitle
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
