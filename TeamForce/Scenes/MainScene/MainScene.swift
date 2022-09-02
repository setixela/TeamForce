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

   private lazy var errorBlock = CommonErrorBlock<Design>()

   private weak var activeScreen: Scenarible?

   private var currentState = MainSceneState.initial

   // MARK: - Start

   override func start() {
      mainVM.header.set_text("Баланс")
      mainVM.bodyStack.set_arrangedModels([
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
            self?.presentTransactModel(self?.transactModel)
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
            mainVM.profileButton.set_url(TeamForceEndpoints.urlBase + photoUrl)
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
         .set_arrangedModels([
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
         .set_arrangedModels([
            model
         ])
   }

   // Presenting Transact
   private func presentTransactModel(_ model: TransactScene<Asset>?) {
      guard
         let model = model,
         let baseView = vcModel?.view
      else { return }

      let offset: CGFloat = 40
      let view = model.uiView

      model
         .on(\.finishWithSuccess) { [weak self] in
            self?.presentTransactSuccessView($0)
            self?.activeScreen?.scenario.start()
         }
         .on(\.cancelled) { [weak self] in
            self?.activeScreen?.scenario.start()
         }

      baseView.addSubview(view)
      view.addAnchors.fitToViewInsetted(baseView, .init(top: offset, left: 0, bottom: 0, right: 0))
   }

   private func presentTransactSuccessView(_ data: StatusViewInput) {
      let model = TransactionStatusViewModel<Design>()
      model.onEvent(\.didHide) {
         print()
      }

      guard
         let baseView = vcModel?.view
      else { return }
      let offset: CGFloat = 40
      let view = model.uiView

      model.setup(info: data.sendCoinInfo, username: data.username, foundUser: data.foundUser)

      baseView.addSubview(view)
      view.addAnchors.fitToViewInsetted(baseView, .init(top: offset, left: 0, bottom: 0, right: 0))
   }
}

// MARK: - Header animation

extension MainScene {
   private func presentHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.setState(.hideHeaderTitle)
         //self.vcModel?.sendEvent(\.setTitle, "История")
      }
   }

   private func hideHeader() {
      UIView.animate(withDuration: 0.36) {
       //  self.vcModel?.sendEvent(\.setTitle, "")
         self.mainVM.setState(.presentHeaderTitle)
      }
   }
}
