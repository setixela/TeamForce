//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import PromiseKit
import RealmSwift
import UIKit

final class MainScene<Asset: AssetProtocol>: BaseSceneModel<
    DefaultVCModel,
    StackWithBottomPanelModel,
    Asset,
    Void
    //Promise<UserData>
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

    private let sideBarModel = SideBarModel<Asset>()

    private let menuButton = BarButtonModel()
//        .sendEvent(\.initWithImage, Design.icon.make(\.sideMenu))

    // MARK: - Start

    override func start() {
        sideBarModel.delegate = self
        sideBarModel.start()
        
        menuButton
            .sendEvent(\.initWithImage, Design.icon.make(\.sideMenu))
        
        presentModel(balanceViewModel)

        mainViewModel.bottomStackModel
            .set(.axis(.horizontal))
            .set(.padding(.zero))
            .set(.spacing(0))
            .set(.backColor(.black))

        mainViewModel.bottomStackModel
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

        mainViewModel.topStackModel
            .set(Design.State.mainView.default)
            .set(.models([
                model
            ]))
    }
}

protocol MainSceneDelegate: AnyObject {
    func presentModelAfterHide(_ model: MainSceneViewModel)
}

extension MainScene: MainSceneDelegate {
    func presentModelAfterHide(_ model: MainSceneViewModel) {
        switch model {
        case .history:
            presentModel(historyViewModel)
        case .transact:
            presentModel(transactViewModel)
        case .balance:
            presentModel(balanceViewModel)
        }
    }
}

