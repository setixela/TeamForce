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
    Promise<UserData>
> {
    // MARK: - Balance View Model

    private lazy var balanceViewModel = BalanceViewModel<ProductionAsset>()
    private lazy var transactViewModel = ImageViewModel() // TODO:
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

        guard
            let realm = try? Realm(),
            let token = realm.objects(Token.self).first
        else {
            return
        }

        print(token.token)
    }
}

extension MainScene {
    private func presentModel(_ model: UIViewModel?) {
        guard let model = model else { return }
        //  model.start()

        mainViewModel.stackModel
            .set(.models([
                model
            ]))
    }
}


