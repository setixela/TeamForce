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
      MainScreenVM<Asset.Design>,
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
   
   private lazy var selectedModel: Int = 0

   // MARK: - Start

   override func start() {
      vcModel?.sendEvent(\.setNavBarTintColor, Design.color.backgroundBrand)

      mainVM.bodyStack.arrangedModels([
         ActivityIndicator<Design>(),
         Spacer()
      ])

      vcModel?.onEvent(\.viewWillAppear) { [weak self] in
         self?.scenario.start()
      }
      tabBarPanel.button1.setMode(\.normal)
      selectedModel = 0
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
         .on(\.didTap, self) {
            $0.unlockTabButtons()
            $0.mainVM.header.text("Лента событий")
            $0.vcModel?.sendEvent(\.setTitle, "Лента событий")
            $0.presentModel($0.feedViewModel)
            $0.tabBarPanel.button1.setMode(\.normal)
            $0.selectedModel = 0
         }

      tabBarPanel.button2
         .on(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.text("Баланс")
            self?.vcModel?.sendEvent(\.setTitle, "Баланс")
            self?.presentModel(self?.balanceViewModel)
            self?.tabBarPanel.button2.setMode(\.normal)
            self?.selectedModel = 1
         }

      tabBarPanel.buttonMain
         .on(\.didTap) { [weak self] in
            self?.presentTransactModel(self?.transactModel)
         }

      tabBarPanel.button3
         .on(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.text("История")
            self?.vcModel?.sendEvent(\.setTitle, "История")
            self?.presentModel(self?.historyViewModel)
            self?.tabBarPanel.button3.setMode(\.normal)
            self?.selectedModel = 2
         }

      tabBarPanel.button4
         .on(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.text("Настройки")
            self?.vcModel?.sendEvent(\.setTitle, "Настройки")
            self?.presentModel(self?.settingsViewModel)
            self?.tabBarPanel.button4.setMode(\.normal)
            self?.selectedModel = 3
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
         switch selectedModel {
         case 0:
            presentModel(feedViewModel)
         case 1:
            presentModel(balanceViewModel)
         case 2:
            presentModel(historyViewModel)
         case 3:
            presentModel(settingsViewModel)
         default:
            print("selected model error")
         }

         configButtons()

         mainVM.profileButton.on(\.didTap) {
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
         .on(\.sendButtonPressed, self) {
            $0.bottomPopupPresenter.send(\.hide)
            $0.activeScreen?.scenario.start()
         }
         .on(\.finishWithSuccess, self) {
            $0.presentTransactSuccessView($1)
            $0.activeScreen?.scenario.start()
         }
         .on(\.finishWithError, self) {
            $0.presentErrorPopup()
            $0.activeScreen?.scenario.start()
         }
         .on(\.cancelled, self) {
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

      model.on(\.didClosed, self) {
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
