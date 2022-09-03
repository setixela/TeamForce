//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import ReactiveWorks
import UIKit

typealias CommunicableUIViewModel = UIViewModel & Communicable
typealias ScenaribleCommunicableUIViewModel = Scenarible & Communicable & UIViewModel

enum MainSceneState {
   case initial
   case profileDidLoad(UserData)
   case loadProfileError
}

final class MainScene<Asset: AssetProtocol>:
   BaseSceneModel<
      DefaultVCModel,
      TripleStacksBrandedVM<Asset.Design>,
      Asset,
      Void
   >, Scenarible
{
   lazy var scenario: Scenario = MainScenario(
      works: MainWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: MainScenarioInputEvents()
   )

   private lazy var balanceViewModel = BalanceScene<Asset>()
   private lazy var historyViewModel = HistoryScene<Asset>()
   private lazy var settingsViewModel = SettingsViewModel<Asset>()
   private lazy var feedViewModel = FeedScene<Asset>()

   private lazy var transactModel: TransactScene = TransactScene<Asset>(vcModel: vcModel)

   private var tabBarPanel: TabBarPanel<Design> { mainVM.footerStack }

   private var currentUser: UserData?

   private lazy var errorBlock = Design.model.common.connectionErrorBlock

   private weak var activeScreen: Scenarible?

   private var currentState = MainSceneState.initial

   private lazy var bottomPopupPresenter = BottomPopupPresenter()

   // MARK: - Start

   override func start() {
      vcModel?.sendEvent(\.setNavBarTintColor, Design.color.backgroundBrand)

      mainVM.header.text("Баланс")
      mainVM.bodyStack.arrangedModels([
         ActivityIndicator<Design>(),
         Spacer()
      ])

      scenario.start()
   }

   private func unlockTabButtons() {
      tabBarPanel.button1.setMode(\.inactive)
      tabBarPanel.button2.setMode(\.inactive)
      tabBarPanel.button3.setMode(\.inactive)
      tabBarPanel.button4.setMode(\.inactive)
   }
}

private extension MainScene {
   func configButtons() {
      tabBarPanel.button1
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.text("Лента событий")
            self?.vcModel?.sendEvent(\.setTitle, "Лента событий")
            self?.presentModel(self?.feedViewModel)
            self?.tabBarPanel.button1.setMode(\.normal)
         }

      tabBarPanel.button2
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.text("Баланс")
            self?.vcModel?.sendEvent(\.setTitle, "Баланс")
            self?.presentModel(self?.balanceViewModel)
            self?.tabBarPanel.button2.setMode(\.normal)
         }

      tabBarPanel.buttonMain
         .onEvent(\.didTap) { [weak self] in
            self?.presentTransactModel(self?.transactModel)
         }

      tabBarPanel.button3
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.text("История")
            self?.vcModel?.sendEvent(\.setTitle, "История")
            self?.presentModel(self?.historyViewModel)
            self?.tabBarPanel.button3.setMode(\.normal)
         }

      tabBarPanel.button4
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.text("Настройки")
            self?.vcModel?.sendEvent(\.setTitle, "Настройки")
            self?.presentModel(self?.settingsViewModel)
            self?.tabBarPanel.button4.setMode(\.normal)
         }
   }
}

// MARK: - State machine

extension MainScene: StateMachine {
   func setState(_ state: MainSceneState) {
      currentState = state

      switch state {
      case .initial:
         break
      case .profileDidLoad(let userData):
         currentUser = userData

         presentModel(balanceViewModel)
         tabBarPanel.button2.setMode(\.normal)

         configButtons()

         mainVM.profileButton.onEvent(\.didTap) {
            Asset.router?.route(\.profile, navType: .push)
         }

         if let photoUrl = currentUser?.profile.photo {
            mainVM.profileButton.url(TeamForceEndpoints.urlBase + photoUrl)
         }
      case .loadProfileError:
         presentModel(errorBlock)
         scenario.start()
      }
   }
}

// MARK: - Presenting sub scenes

extension MainScene {
   // Presenting Balance, Feed, History
   private func presentModel<M: Scenarible & Communicable & UIViewModel>(_ model: M?) where M.Events == MainSceneEvents {
      guard let model = model else { return }

      model.onEvent(\.willEndDragging) { [weak self] velocity in
         if velocity > 0 {
            self?.presentHeader()
         } else if velocity < 0 {
            self?.hideHeader()
         }
      }
      mainVM.bodyStack
         .arrangedModels([
            model
         ])

      model.scenario.start()
      model.sendEvent(\.userDidLoad, currentUser)

      activeScreen = model
   }

   // Presenting Settings
   private func presentModel<M: UIViewModel>(_ model: M?) {
      guard let model = model else { return }

      mainVM.bodyStack
         .arrangedModels([
            model
         ])
   }

   // Presenting Transact
   private func presentTransactModel(_ model: TransactScene<Asset>?) {
      guard
         let model = model,
         let baseView = vcModel?.view
      else { return }

      model
         .on(self, \.sendButtonPressed) {
            $0.bottomPopupPresenter.send(\.hide)
            $0.activeScreen?.scenario.start()
         }
         .on(self, \.finishWithSuccess) {
            $0.presentTransactSuccessView($1)
            $0.activeScreen?.scenario.start()
         }
         .on(self, \.finishWithError) {
            $0.presentErrorPopup()
            $0.activeScreen?.scenario.start()
         }
         .on(self, \.cancelled) {
            $0.bottomPopupPresenter.send(\.hide)
            $0.activeScreen?.scenario.start()
         }

      bottomPopupPresenter.send(\.present, (model: model, onView: baseView.rootSuperview))
   }

   private func presentTransactSuccessView(_ data: StatusViewInput) {
      let model = Design.model.transact.transactSuccessViewModel

      model.onEvent(\.finished) { [weak self] in
         self?.bottomPopupPresenter.send(\.hide)
      }

      guard
         let baseView = vcModel?.view
      else { return }

      model.setup(info: data.sendCoinInfo, username: data.username, foundUser: data.foundUser)

      bottomPopupPresenter.send(\.present, (model: model, onView: baseView.rootSuperview))
   }

   private func presentErrorPopup() {
      let model = Design.model.common.systemErrorBlock

      model.on(self, \.didClosed) {
         $0.bottomPopupPresenter.send(\.hide)
      }

      guard
         let baseView = vcModel?.view
      else { return }

      bottomPopupPresenter.send(\.presentAuto, (model: model, onView: baseView.rootSuperview))
   }
}

// MARK: - Header animation

extension MainScene {
   private func presentHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.setState(.hideHeaderTitle)
      } completion: { _ in
         self.vcModel?.sendEvent(\.setNavBarTintColor, Design.color.textInvert)
      }
   }

   private func hideHeader() {
      vcModel?.sendEvent(\.setNavBarTintColor, Design.color.backgroundBrand)
      UIView.animate(withDuration: 0.36) {
         self.mainVM.setState(.presentHeaderTitle)
      }
   }
}
