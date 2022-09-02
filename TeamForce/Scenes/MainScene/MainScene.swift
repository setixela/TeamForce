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

   private var darkView: UIView?

   // MARK: - Start

   override func start() {
      vcModel?.sendEvent(\.setNavBarTintColor, Design.color.backgroundBrand)

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

   var viewTranslation = CGPoint(x: 0, y: 0)
   @objc func handleDismiss(sender: UIPanGestureRecognizer) {
      guard let view = sender.view else { return }

      switch sender.state {
      case .changed:
         viewTranslation = sender.translation(in: view)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(translationX: 0,
                                               y: self.viewTranslation.y > 0 ? self.viewTranslation.y : 0)
         })
      case .ended:
         if viewTranslation.y < 200 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               view.transform = .identity
            })
         } else {
            hideView(view)
         }
      default:
         break
      }
   }

   @objc func didTapOnView(sender: UITapGestureRecognizer) {
      sender.view?.endEditing(true)
   }

   private func hideView(_ view: UIView) {
      UIView.animate(withDuration: 0.23) {
         self.darkView?.alpha = 0
         view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
      } completion: { _ in
         self.darkView?.removeFromSuperview()
         self.darkView = nil
         view.removeFromSuperview()
         view.transform = .identity
      }
   }
}

private extension MainScene {
   func configButtons() {
      tabBarPanel.button1
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Лента событий")
            self?.vcModel?.sendEvent(\.setTitle, "Лента событий")
            self?.presentModel(self?.feedViewModel)
            self?.tabBarPanel.button1.setMode(\.normal)
         }

      tabBarPanel.button2
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Баланс")
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
            self?.mainVM.header.set_text("История")
            self?.vcModel?.sendEvent(\.setTitle, "История")
            self?.presentModel(self?.historyViewModel)
            self?.tabBarPanel.button3.setMode(\.normal)
         }

      tabBarPanel.button4
         .onEvent(\.didTap) { [weak self] in
            self?.unlockTabButtons()
            self?.mainVM.header.set_text("Настройки")
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
            self?.hideView(view)
            self?.activeScreen?.scenario.start()
         }

      let height = baseView.frame.height

      view.translatesAutoresizingMaskIntoConstraints = true

      darkView = UIView(frame: baseView.frame)
      darkView?.backgroundColor = Design.color.iconContrast
      darkView?.alpha = 0
      baseView.rootSuperview.addSubview(darkView!)
      baseView.rootSuperview.addSubview(view)

      view.frame.size = .init(width: baseView.frame.width, height: height - offset)
      view.frame.origin = .init(x: 0, y: height)

      UIView.animate(withDuration: 0.5) {
         view.frame.origin = .init(x: 0, y: offset)
         self.darkView?.alpha = 0.75
      } completion: { _ in
         view.addAnchors.fitToViewInsetted(baseView, .init(top: offset, left: 0, bottom: 0, right: 0))
         view.layoutIfNeeded()
      }

      view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
      view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnView)))
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
