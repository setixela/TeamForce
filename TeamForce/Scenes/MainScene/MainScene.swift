//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import ReactiveWorks
import UIKit

final class MainScene<Asset: AssetProtocol>:
   BaseSceneModel<
      DefaultVCModel,
      TripleStacksBrandedVM<Asset.Design>,
      Asset,
      Void
   >
{
   lazy var balanceViewModel = BalanceViewModel<Asset>()
   lazy var transactViewModel = TransactScene<Asset>()
   lazy var historyViewModel = HistoryScene<Asset>()
   lazy var settingsViewModel = SettingsViewModel<Asset>()
   lazy var profileViewModel = ProfileViewModel<Asset>()

   lazy var feedViewModel = FeedScene<Asset>()

   var tabBarPanel: TabBarPanel<Design> { mainVM.footerStack }

   // MARK: - Side bar

   private let sideBarModel = SideBarModel<Asset>()
   private let menuButton = BarButtonModel()

   private lazy var useCase = Asset.apiUseCase

   private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)

   // MARK: - Start

   override func start() {
      sideBarModel.start()

      mainVM.header.set_text("Баланс")

      menuButton
         .sendEvent(\.initWithImage, Design.icon.sideMenu)

      presentModel(balanceViewModel)

      tabBarPanel.button1
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Лента событий")
            self?.presentModel(self?.feedViewModel)
            self?.tabBarPanel.button1.setMode(\.normal)
         }

      tabBarPanel.button2
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Баланс")
            self?.presentModel(self?.balanceViewModel)
            self?.tabBarPanel.button2.setMode(\.normal)
         }

      tabBarPanel.buttonMain
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Тра")
            self?.presentModel(self?.transactViewModel)
            self?.tabBarPanel.button2.setMode(\.normal)
         }

      tabBarPanel.button3
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("История")
            self?.presentModel(self?.historyViewModel)
            self?.tabBarPanel.button3.setMode(\.normal)
         }

      tabBarPanel.button4
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Настройки")
            self?.presentModel(self?.settingsViewModel)
            self?.tabBarPanel.button4.setMode(\.normal)
         }

      mainVM.profileButton.onEvent(\.didTap) { [weak self] in
         self?.unlockTabButtons()
         self?.mainVM.header.set_text("Профиль")
         self?.presentModel(self?.profileViewModel)
      }
   }

   private func unlockTabButtons() {
      tabBarPanel.button1.setMode(\.inactive)
      tabBarPanel.button2.setMode(\.inactive)
      tabBarPanel.button3.setMode(\.inactive)
      tabBarPanel.button4.setMode(\.inactive)
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
      mainVM.bodyStack
         .set_arrangedModels([
            model
         ])
   }
}

private extension MainScene {
   func loadProfile() {
      safeStringStorageModel
         .doAsync("token")
         .onFail {
            print("token not found")
         }
         .doMap {
            TokenRequest(token: $0)
         }
         .doNext(worker: userProfileApiModel)
         .onSuccess { [weak self] userData in
//            self?.
//            self?.setLabels(userData: userData)
         }.onFail {
            print("load profile error")
         }
   }
}
