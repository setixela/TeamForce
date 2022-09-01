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

   private lazy var balanceViewModel = BalanceViewModel<Asset>()
   private lazy var historyViewModel = HistoryScene<Asset>()
   private lazy var settingsViewModel = SettingsViewModel<Asset>()
   private lazy var feedViewModel = FeedScene<Asset>()

   private lazy var transactModel: TransactScene = TransactScene<Asset>(vcModel: vcModel)

   private var tabBarPanel: TabBarPanel<Design> { mainVM.footerStack }

   private var currentUser: UserData?

   private weak var activeScreen: ModelProtocol?

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
      activeScreen = model
   }

   private func presentModel<M: UIViewModel>(_ model: M?) {
      guard let model = model else { return }

      mainVM.bodyStack
         .set_arrangedModels([
            model
         ])
      activeScreen = model
   }

   private func presentBottomPopupModel<M: UIViewModel & Communicable>(_ model: M?) where M.Events == TransactEvents {
      guard
         let model = model,
         let baseView = vcModel?.view
      else { return }

      let offset: CGFloat = 40
      let view = model.uiView

      model
         .onEvent(\.finishWithSuccess) { [weak self] in
            self?.presentTransactSuccessView($0)
            self?.activeScreen?.start()
         }
         .onEvent(\.cancelled) { [weak self] in
            self?.activeScreen?.start()
         }

      baseView.addSubview(view)
      view.addAnchors.fitToViewInsetted(baseView, .init(top: offset, left: 0, bottom: 0, right: 0))
      // activeScreen = model
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
         tabBarPanel.button2.setMode(\.normal)
         
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

               self?.transactModel.start()
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

         if let photoUrl = currentUser?.profile.photo {
            mainVM.profileButton.set_url(TeamForceEndpoints.urlBase + photoUrl)
         }
      case .loadProfileError:
         break
      }
   }
}

final class ActivityIndicator<Design: DSP>: BaseViewModel<UIActivityIndicatorView>, Stateable {
   typealias State = ViewState

   override func start() {
      set_size(.square(100))
      view.startAnimating()
      view.color = Design.color.iconBrand
      view.contentScaleFactor = 1.33
   }
}
