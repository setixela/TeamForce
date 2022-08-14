//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import PromiseKit
import ReactiveWorks
import UIKit

final class MainScene<Asset: AssetProtocol>: BaseSceneModel<
  DefaultVCModel,
  DoubleStacksModel,
  Asset,
  Void
> {
  // MARK: - Balance View Model

  private lazy var balanceViewModel = BalanceViewModel<Asset>()
  private lazy var transactViewModel = TransactViewModel<Asset>()
  private lazy var historyViewModel = HistoryViewModel<Asset>()

  private lazy var balanceButton = Design.button.tabBar
    .set(.title("Баланс"))
    .set(.image(Design.icon.coinLine))
    .onEvent(\.didTap) { [weak self] in
      self?.presentModel(self?.balanceViewModel)
    }

  private lazy var transactButton = Design.button.tabBar
    .set(.title("Новый перевод"))
    .set(.image(Design.icon.upload2Fill))
    .onEvent(\.didTap) { [weak self] in
      self?.presentModel(self?.transactViewModel)
    }

  private lazy var historyButton = Design.button.tabBar
    .set(.title("История"))
    .set(.image(Design.icon.historyLine))
    .onEvent(\.didTap) { [weak self] in
      self?.presentModel(self?.historyViewModel)
    }

  // MARK: - Side bar

  private let sideBarModel = SideBarModel<Asset>()

  private let menuButton = BarButtonModel()

  // MARK: - Start

  override func start() {
    sideBarModel.start()

    menuButton
      .sendEvent(\.initWithImage, Design.icon.sideMenu)

    presentModel(balanceViewModel)

    mainViewModel
      .set(.backColor(Design.color.background))

    mainViewModel.bottomStackModel
      .set(.axis(.horizontal))
      .set(.padding(.zero))
      .set(.spacing(0))
      .set(.backColor(.black))
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

    configureSideBarItemsEvents()
  }

  private func configureSideBarItemsEvents() {
    weak var weakSelf = self

    sideBarModel.item1
      .onEvent(\.didTap) {
        weakSelf?.sideBarModel.sendEvent(\.hide)
        weakSelf?.presentModel(weakSelf?.balanceViewModel)
      }

    sideBarModel.item2
      .onEvent(\.didTap) {
        weakSelf?.sideBarModel.sendEvent(\.hide)
        weakSelf?.presentModel(weakSelf?.transactViewModel)
      }

    sideBarModel.item3
      .onEvent(\.didTap) {
        weakSelf?.sideBarModel.sendEvent(\.hide)
        weakSelf?.presentModel(weakSelf?.historyViewModel)
      }
  }
}

extension MainScene {
  private func presentModel(_ model: UIViewModel?) {
    guard let model = model else { return }

   // model.start()
    mainViewModel.topStackModel
      .set(Design.state.stack.default)
      .set(.models([
        model
      ]))
  }
}