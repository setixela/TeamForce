//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import ReactiveWorks
import UIKit

// 177

typealias CommunicableUIViewModel = UIViewModel & Communicable

final class MainScene<Asset: AssetProtocol>:
   BaseSceneModel<
      DefaultVCModel,
      TripleStacksBrandedVM<Asset.Design>,
      Asset,
      Void
   >
{
   lazy var balanceViewModel = BalanceViewModel<Asset>()
//   lazy var transactViewModel = TransactScene<Asset>()
   lazy var historyViewModel = HistoryScene<Asset>()
   lazy var settingsViewModel = SettingsViewModel<Asset>()
   // lazy var profileViewModel = ProfileViewModel<Asset>()

   lazy var feedViewModel = FeedScene<Asset>()

   var tabBarPanel: TabBarPanel<Design> { mainVM.footerStack }

   // MARK: - Side bar

   private let menuButton = BarButtonModel()

   private lazy var useCase = Asset.apiUseCase

   private lazy var userProfileApiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorageModel = StringStorageWorker(engine: Asset.service.safeStringStorage)

   // MARK: - Start

   override func start() {
      mainVM.header.set_text("Баланс")
      // mainVM.profileButton.set_url(Self.)

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
            Asset.router?.route(\.transaction, navType: .presentModally(.formSheet))
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
         // self?.unlockTabButtons()
         Asset.router?.route(\.profile, navType: .push)
//         self?.mainVM.header.set_text("Профиль")
//         self?.presentModel(self?.profileViewModel)
      }
   }

   private func unlockTabButtons() {
      tabBarPanel.button1.setMode(\.inactive)
      tabBarPanel.button2.setMode(\.inactive)
      tabBarPanel.button3.setMode(\.inactive)
      tabBarPanel.button4.setMode(\.inactive)
   }
}

extension MainScene {
   private func presentModel<M: UIViewModel & Communicable>(_ model: M?) where M.Events == MainSceneEvents {
      guard let model = model else { return }
      model.onEvent(\.willEndDragging) { [weak self] velocity in
         if velocity > 0 {
            UIView.animate(withDuration: 0.36) {
               self?.mainVM.setState(.hideHeaderTitle)
               self?.vcModel?.sendEvent(\.setTitle, "История")
            }

         } else if velocity < 0 {
            UIView.animate(withDuration: 0.36) {
               self?.vcModel?.sendEvent(\.setTitle, "")
               self?.mainVM.setState(.presentHeaderTitle)
            }
         }
      }
      mainVM.bodyStack
         .set_arrangedModels([
            model
         ])
      model.sendEvent(\.didAppear)
   }

   private func presentModel<M: UIViewModel>(_ model: M?) {
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
         .onSuccess { [weak self] _ in
//            self?.
//            self?.setLabels(userData: userData)
         }.onFail {
            print("load profile error")
         }
   }
}
