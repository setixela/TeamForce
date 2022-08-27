//
//  TransactScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import SwiftUI
import UIKit

enum TransactState {
   case initial
   case loadProfilError
   case loadTransactionsError

   case loadTokensSuccess
   case loadTokensError

   case loadBalanceSuccess(Int)
   case loadBalanceError

   case loadUsersListSuccess([FoundUser])
   case loadUsersListError

   case presentFoundUser([FoundUser])
   case presentUsers([FoundUser])
   case listOfFoundUsers([FoundUser])

   case userSelectedSuccess(FoundUser, Int)

   case userSearchTFDidEditingChangedSuccess

   case sendCoinSuccess((String, SendCoinRequest))
   case sendCoinError

   case coinInputSuccess(String, Bool)
   case reasonInputSuccess(String, Bool)
}

final class TransactScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Void
>, Scenarible {
   typealias State = StackState

   lazy var scenario = TransactScenario(
      works: TransactWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: TransactScenarioEvents(
         userSearchTXTFLDBeginEditing: viewModels.userSearchTextField.onEvent(\.didBeginEditing),
         userSearchTFDidEditingChanged: viewModels.userSearchTextField.onEvent(\.didEditingChanged),
         userSelected: viewModels.foundUsersList.onEvent(\.didSelectRow),
         sendButtonEvent: viewModels.sendButton.onEvent(\.didTap),
         transactInputChanged: viewModels.transactInputViewModel.textField.onEvent(\.didEditingChanged),
         reasonInputChanged: viewModels.reasonTextView.onEvent(\.didEditingChanged),
         anonymousSetOff: options.anonimParamModel.switcher.onEvent(\.turnedOff),
         anonymousSetOn: options.anonimParamModel.switcher.onEvent(\.turnedOn)
      )
   )

   private lazy var viewModels = TransactViewModels<Design>()
   private lazy var closeButton = ButtonModel()
      .set_title(Design.Text.title.close)
      .set_textColor(Design.color.textBrand)

   private lazy var options = TransactOptionsVM<Design>()
   private lazy var viewModelsWrapper = ScrollViewModelY()
      .set(.spacing(Grid.x16.value))
      .set(.models([
         viewModels.balanceInfo,
         viewModels.userSearchTextField,
         viewModels.foundUsersList,
         viewModels.transactInputViewModel,
         viewModels.reasonTextView,
         viewModels.addPhotoButton,
         options,
         Grid.x32.spacer
      ]))

   private var currentState = TransactState.initial

   // MARK: - Start

   override func start() {
      configure()

      vcModel?
         .onEvent(\.viewWillAppear) { [weak self] in
            self?.setToInitialCondition()
            self?.scenario.start()
         }

      closeButton.onEvent(\.didTap) { [weak self] in
         self?.vcModel?.dismiss(animated: true)
      }
   }

   func configure() {
      mainVM.topStackModel.set(Design.state.stack.bodyStack)
      mainVM.topStackModel
         .set_axis(.vertical)
         .set_distribution(.fill)
         .set_alignment(.fill)
         .set_arrangedModels([
            Wrapped3X(
               Spacer(50),
               LabelModel()
                  .set_alignment(.center)
                  .set(Design.state.label.body3)
                  .set_text(Design.Text.title.newTransact),
               closeButton
            )
            .set_height(Grid.x32.value)
            .set_distribution(.equalCentering)
            .set_padTop(-Grid.x4.value)
            .set_padBottom(Grid.x20.value),
            //            .set_zPosition(1000),

            viewModelsWrapper
         ])

      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .set_arrangedModels([
            viewModels.sendButton
         ])
   }

   private func setToInitialCondition() {
      clearFields()
      scenario.works.reset.doSync()
      hideViews()
      viewModels.sendButton.set(Design.state.button.inactive)
   }

   private func hideViews() {
      viewModels.transactInputViewModel.set(.hidden(true))
      viewModels.sendButton.set(Design.state.button.inactive)
      viewModels.reasonTextView.set(.hidden(true))
      options.set_hidden(true)
      viewModels.addPhotoButton.set_hidden(true)
   }

   private func clearFields() {
      viewModels.userSearchTextField.set_text("")
      viewModels.transactInputViewModel.textField.set_text("")
      viewModels.reasonTextView.set(.text(""))
   }
}

extension TransactScene: StateMachine {
   func setState(_ state: TransactState) {
      debug(state)

      switch state {
      case .initial:
         hideHUD()
      //
      case .loadProfilError:
         break
      //
      case .loadTransactionsError:
         break
      //
      case .loadTokensSuccess:
         viewModels.userSearchTextField.set_hidden(false)
      //
      case .loadTokensError:
         viewModels.userSearchTextField.set_hidden(true)
      //
      case .loadBalanceSuccess(let balance):
         viewModels.balanceInfo.models.down.label.set_text(String(balance))
      //
      case .loadBalanceError:
         print("balance not loaded")
      //
      case .loadUsersListSuccess(let users):
         presentFoundUsers(users: users)
      //
      case .loadUsersListError:
         viewModels.foundUsersList.set_hidden(true)
      //
      case .presentFoundUser(let users):
         viewModels.foundUsersList.set_hidden(true)
         presentFoundUsers(users: users)
      //
      case .presentUsers(let users):
         viewModels.foundUsersList.set_hidden(true)
         presentFoundUsers(users: users)
      //
      case .listOfFoundUsers(let users):
         presentFoundUsers(users: users)
      //
      case .userSelectedSuccess(_, let index):
         viewModels.userSearchTextField.set_hidden(true)

         if case .userSelectedSuccess = currentState {
            viewModels.userSearchTextField.set_hidden(false)
            viewModels.foundUsersList.set_hidden(true)
            setState(.initial)
            return
         }

         UIView.animate(withDuration: 0.33) {
            self.setToInitialCondition()
            self.clearFields()

            self.viewModels.foundUsersList.set(.removeAllExceptIndex(index))

            self.viewModels.userSearchTextField.set_hidden(true)
            self.viewModels.transactInputViewModel.set_hidden(false)
            self.viewModels.reasonTextView.set_hidden(false)
            self.options.set_hidden(false)
            self.viewModels.addPhotoButton.set_hidden(false)
            self.mainVM.view.layoutIfNeeded()
         }
      //
      case .userSearchTFDidEditingChangedSuccess:
         hideHUD()
      //
      case .sendCoinSuccess(let tuple):
         viewModels.transactionStatusView.start()
         guard
            let superview = vcModel?.view.superview?.superview
         else { return }

         let input = StatusViewInput(baseView: superview,
                                     sendCoinInfo: tuple.1,
                                     username: tuple.0)
         viewModels.transactionStatusView.sendEvent(\.presentOnScene, input)

         viewModels.transactionStatusView.onEvent(\.didHide) { [weak self] in
            self?.vcModel?.dismiss(animated: true)
         }
      //
      case .sendCoinError:
         presentAlert(text: "Не могу послать деньгу")
      //
      case .coinInputSuccess(let text, let isCorrect):
         viewModels.transactInputViewModel.textField.set(.text(text))
         if isCorrect {
            viewModels.transactInputViewModel.setState(.normal(text))
            viewModels.sendButton.set(Design.state.button.default)
         } else {
            viewModels.transactInputViewModel.setState(.noInput)
            viewModels.transactInputViewModel.textField.set(.text(text))
            viewModels.sendButton.set(Design.state.button.inactive)
         }
      //
      case .reasonInputSuccess(let text, let isCorrect):
         viewModels.reasonTextView.set(.text(text))
         if isCorrect {
            viewModels.sendButton.set(Design.state.button.default)
         } else {
            viewModels.reasonTextView.set(.text(text))
            viewModels.sendButton.set(Design.state.button.inactive)
         }
      }

      currentState = state
   }
}

class ImageLabelLabelMRD: Combos<SComboMRD<ImageViewModel, LabelModel, LabelModel>> {}

private extension TransactScene {
   func hideHUD() {
      viewModels.transactInputViewModel.set(.hidden(true))
      viewModels.sendButton.set(Design.state.button.inactive)
      viewModels.reasonTextView.set(.hidden(true))
      options.set_hidden(true)
      viewModels.addPhotoButton.set_hidden(true)
   }

   func presentFoundUsers(users: [FoundUser]) {
//      options.set(.hidden(true))
      viewModels.foundUsersList.set(.items(users))
      viewModels.foundUsersList.set(.hidden(users.isEmpty ? true : false))
   }

   func presentAlert(text: String) {
      let alert = UIAlertController(title: "Ошибка",
                                    message: text,
                                    preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                    style: .default))

      UIApplication.shared.keyWindow?.rootViewController?
         .present(alert, animated: true, completion: nil)
   }
}
