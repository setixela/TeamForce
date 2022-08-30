//
//  TransactModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 29.08.2022.
//

import ReactiveWorks
import UIKit

struct TransactEvents: InitProtocol {
   var cancelled: Event<Void>?
   var finishWithSuccess: Event<StatusViewInput>?
}

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

final class TransactModel<Asset: AssetProtocol>: DoubleStacksModel, Assetable, Scenarible, Communicable {
   typealias State = StackState

   var events = TransactEvents()

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
         viewModels.foundUsersList,
         viewModels.transactInputViewModel,
         viewModels.reasonTextView,
         viewModels.addPhotoButton,
         options
      ]))

   private var currentState = TransactState.initial

   // MARK: - Start

   override func start() {
      super.start()

      configure()

      closeButton.onEvent(\.didTap) { [weak self] in
         self?.sendEvent(\.cancelled)
         self?.view.removeFromSuperview()
      }

      view.onEvent(\.willAppear) { [weak self] in
         self?.setToInitialCondition()
         self?.scenario.start()
      }
   }

   func configure() {
      topStackModel
         .set_safeAreaOffsetDisabled()
         .set_axis(.vertical)
         .set_distribution(.fill)
         .set_alignment(.fill)
         .set_backColor(Design.color.background)
         .set_padding(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
         .set_cornerRadius(Design.params.cornerRadiusMedium)
         .set_arrangedModels([
            //
            Wrapped3X(
               Spacer(50),
               LabelModel()
                  .set_alignment(.center)
                  .set(Design.state.label.body3)
                  .set_text(Design.Text.title.newTransact),
               closeButton
            )
            .set_height(64)
            .set_alignment(.center)
            .set_distribution(.equalCentering),
            //
            viewModels.userSearchTextField,
            Grid.x8.spacer,
            viewModelsWrapper
         ])

      bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .set_arrangedModels([
            viewModels.sendButton
         ])
   }

   private func setToInitialCondition() {
      clearFields()
      scenario.works.reset.doSync()

      viewModels.sendButton.set(Design.state.button.inactive)

      applySelectUserMode()
   }

   private func clearFields() {
      viewModels.userSearchTextField.set_text("")
      viewModels.transactInputViewModel.textField.set_text("")
      viewModels.reasonTextView.set_text("")
   }
}

extension TransactModel: StateMachine {
   func setState(_ state: TransactState) {
      debug(state)

      switch state {
      case .initial:
         applySelectUserMode()
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

         viewModelsWrapper.set(.scrollToTop(animated: true))

         UIView.animate(withDuration: 0.1) {
            self.viewModels.foundUsersList.set(.removeAllExceptIndex(index))
            self.view.layoutIfNeeded()
         } completion: { _ in
            self.applyReadyToSendMode()
         }
      //
      case .userSearchTFDidEditingChangedSuccess:
         applySelectUserMode()
      //
      case .sendCoinSuccess(let tuple):

         let sended = StatusViewInput(sendCoinInfo: tuple.1,
                                      username: tuple.0,
                                      foundUser: viewModels.foundUsersList.items.first as! FoundUser)
         sendEvent(\.finishWithSuccess, sended)
         view.removeFromSuperview()
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

private extension TransactModel {
   func applySelectUserMode() {
      viewModels.balanceInfo.set(.hidden(true))
      viewModels.transactInputViewModel.set(.hidden(true))
      viewModels.reasonTextView.set(.hidden(true))
      options.set_hidden(true)
      viewModels.addPhotoButton.set_hidden(true)
      bottomStackModel.set_hidden(true)
   }

   func applyReadyToSendMode() {
      viewModels.balanceInfo.set(.hidden(false))
      viewModels.transactInputViewModel.set(.hidden(false))
      viewModels.reasonTextView.set(.hidden(false))
      options.set_hidden(false)
      viewModels.addPhotoButton.set_hidden(false)
      bottomStackModel.set_hidden(false)
   }
}

private extension TransactModel {
   func presentFoundUsers(users: [FoundUser]) {
      //      options.set(.hidden(true))
      viewModels.foundUsersList.set(.items(users))
      viewModels.foundUsersList.set(.hidden(users.isEmpty ? true : false))
   }

   func presentAlert(text: String) {}
}

extension UIView {
   func clearConstraints() {
//      for subview in self.subviews {
//         subview.clearConstraints()
//      }
      removeConstraints(constraints)
   }
}

class ImageLabelLabelMRD: Combos<SComboMRD<ImageViewModel, LabelModel, LabelModel>> {}
