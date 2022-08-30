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
   >, Scenarible
{
   lazy var scenario = MainScenario(
      works: MainWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: MainScenarioInputEvents()
   )

   lazy var balanceViewModel = BalanceViewModel<Asset>()
   lazy var historyViewModel = HistoryScene<Asset>()
   lazy var settingsViewModel = SettingsViewModel<Asset>()
   lazy var feedViewModel = FeedScene<Asset>()

   lazy var transactModel = TransactModel<Asset>()
//      .onEvent(\.willDisappear) { [weak self] in
//         self?.vcModel?.view.layoutIfNeeded()
//      }

   var tabBarPanel: TabBarPanel<Design> { mainVM.footerStack }

   private var currentUser: UserData?

   // MARK: - Start

   override func start() {
      mainVM.header.set_text("Баланс")

      scenario.start()
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
            self?.presentHeader()
         } else if velocity < 0 {
            self?.hideHeader()
         }
      }
      mainVM.bodyStack
         .set_arrangedModels([
            model
         ])
      model.sendEvent(\.userDidLoad, currentUser)
   }

   private func presentModel<M: UIViewModel>(_ model: M?) {
      guard let model = model else { return }

      mainVM.bodyStack
         .set_arrangedModels([
            model
         ])
   }

   private func presentBottomPopupModel<M: UIViewModel & Communicable>(_ model: M?) where M.Events == TransactEvents {
      guard
         let model = model,
         let baseView = vcModel?.view
      else { return }

      let offset: CGFloat = 40
      let view = model.uiView

      model.onEvent(\.finishWithSuccess) { [weak self] in
         self?.presentTransactSuccessView($0)
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

      baseView.addSubview(view)
      view.addAnchors.fitToViewInsetted(baseView, .init(top: offset, left: 0, bottom: 0, right: 0))
   }

   private func presentHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.setState(.hideHeaderTitle)
         self.vcModel?.sendEvent(\.setTitle, "История")
      }
   }

   private func hideHeader() {
      UIView.animate(withDuration: 0.36) {
         self.vcModel?.sendEvent(\.setTitle, "")
         self.mainVM.setState(.presentHeaderTitle)
      }
   }
}

enum MainSceneState {
   case profileDidLoad(UserData)
   case loadProfileError
}

extension MainScene: StateMachine {
   func setState(_ state: MainSceneState) {
      switch state {
      case .profileDidLoad(let userData):
         currentUser = userData

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

               self?.presentBottomPopupModel(self?.transactModel)
               // Asset.router?.route(\.transaction, navType: .presentModally(.formSheet))
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

         mainVM.profileButton.onEvent(\.didTap) {
            Asset.router?.route(\.profile, navType: .push)
         }
      case .loadProfileError:
         break
      }
   }
}
