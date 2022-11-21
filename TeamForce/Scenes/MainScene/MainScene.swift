//
//  MainScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.06.2022.
//

import ReactiveWorks
import UIKit

typealias EventableUIViewModel = UIViewModel & Eventable
typealias ScenaribleEventableUIViewModel = Scenarible & Eventable & UIViewModel

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
   >, Scenarible, Configurable
{
   lazy var scenario: Scenario = MainScenario(
      works: MainWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: MainScenarioInputEvents()
   )

   private lazy var balanceViewModel = BalanceScene<Asset>()
   private lazy var historyViewModel = HistoryScene<Asset>()
   private lazy var feedViewModel = FeedScene<Asset>()
   private lazy var challengesViewModel = ChallengesScene<Asset>()

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
      vcModel?.on(\.viewDidLoad, self) {
         $0.configure()
      }
   }

   func configure() {
      vcModel?
         .statusBarStyle(.lightContent)
         .titleColor(Design.color.backgroundBrand)

      mainVM.bodyStack.arrangedModels([
         ActivityIndicator<Design>(),
         Spacer()
      ])

      tabBarPanel.button1.setSelfMode(\.normal)
      selectedModel = 0

      mainVM.header.text("События")
      vcModel?.title("События")

      mainVM.notifyButton.on(\.didTap) {
         Asset.router?.route(.push, scene: \.notifications)
      }

      hideHeader()

      scenario.start()
   }

   private func unlockTabButtons() {
      tabBarPanel.button1.setSelfMode(\.inactive)
      tabBarPanel.button2.setSelfMode(\.inactive)
      tabBarPanel.button3.setSelfMode(\.inactive)
      tabBarPanel.button4.setSelfMode(\.inactive)
   }
}

private extension MainScene {
   func configButtons() {
      tabBarPanel.button1
         .on(\.didTap, self) {
            $0.unlockTabButtons()
            $0.mainVM.header.text("События")
            $0.vcModel?.title("События")
            $0.presentModel($0.feedViewModel)
            $0.tabBarPanel.button1.setSelfMode(\.normal)
            $0.selectedModel = 0
         }

      tabBarPanel.button2
         .on(\.didTap, self) {
            $0.unlockTabButtons()
            $0.mainVM.header.text("Баланс")
            $0.vcModel?.title("Баланс")
            $0.presentModel($0.balanceViewModel)
            $0.tabBarPanel.button2.setSelfMode(\.normal)
            $0.selectedModel = 1
         }

      tabBarPanel.buttonMain
         .on(\.didTap, self) {
            $0.presentTransactModel($0.transactModel)
         }

      tabBarPanel.button3
         .on(\.didTap, self) {
            $0.unlockTabButtons()
            $0.mainVM.header.text("История")
            $0.vcModel?.title("История")
            $0.presentModel($0.historyViewModel)
            $0.tabBarPanel.button3.setSelfMode(\.normal)
            $0.selectedModel = 2
         }

      tabBarPanel.button4
         .on(\.didTap, self) {
            $0.unlockTabButtons()
            $0.mainVM.header.text("Челленджи")
            $0.vcModel?.title("Челленджи")
            $0.presentModel($0.challengesViewModel)
            $0.tabBarPanel.button4.setSelfMode(\.normal)
            $0.selectedModel = 3
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
            presentModel(challengesViewModel)
         default:
            print("selected model error")
         }

         configButtons()

         mainVM.profileButton.on(\.didTap) {
            Asset.router?.route(.push, scene: \.myProfile)
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
   private func presentModel<M: ScenaribleEventableUIViewModel>(_ model: M?) where M.Events == MainSceneEvents {
      guard let model = model else { return }

      model.on(\.willEndDragging) { [weak self] velocity in
         if velocity > 0 {
            self?.hideHeader()
         } else if velocity < 0 {
            self?.presentHeader()
         }
      }
      mainVM.bodyStack
         .arrangedModels([
            model
         ])

      model.scenario.start()
      model.send(\.userDidLoad, currentUser)

      activeScreen = model
   }

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
   private func hideHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.setState(.hideHeaderTitle)
      } completion: { _ in
         self.vcModel?.titleColor(Design.color.textInvert)
      }
   }

   private func presentHeader() {
      vcModel?.titleColor(Design.color.transparent)
      UIView.animate(withDuration: 0.36) {
         self.mainVM.setState(.presentHeaderTitle)
      }
   }
}
