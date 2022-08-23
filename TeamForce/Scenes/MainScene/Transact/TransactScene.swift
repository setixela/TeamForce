//
//  TransactScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

struct TransactViewEvent: InitProtocol {}

final class TransactScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Assetable,
   Stateable,
   Scenaryable
{
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
         reasonInputChanged: viewModels.reasonTextView.onEvent(\.didEditingChanged)
      )
   )

   private lazy var viewModels = TransactViewModels<Design>()
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
         viewModels.sendButton,
         Grid.x64.spacer
      ]))

   private var currentState = TransactState.initial

   // MARK: - Start

   override func start() {
      configure()

      view
         .onEvent(\.willAppear) { [weak self] in
            self?.setToInitialCondition()
            self?.scenario.start()
         }
   }

   func configure() {
      set_axis(.vertical)
      set_distribution(.fill)
      set_alignment(.fill)
      set_arrangedModels([
         viewModelsWrapper
      ])
   }



   private func setToInitialCondition() {
      clearFields()
      scenario.works.reset.doSync()
      hideViews()
      viewModels.sendButton.set(Design.state.button.inactive)
   }

//   private func setToSelectedUserState() {
//      clearFields()
//      scenario.works.reset.doSync()
//      hideViews()
//      viewModels.sendButton.set(Design.state.button.inactive)
//   }


   private func hideViews() {
      viewModels.transactInputViewModel.set(.hidden(true))
      viewModels.sendButton.set(.hidden(true))
      viewModels.reasonTextView.set(.hidden(true))
   }

   private func clearFields() {
      viewModels.userSearchTextField.set_text("")
      viewModels.transactInputViewModel.textField.set_text("")
      viewModels.reasonTextView.set(.text(""))
   }
}

extension TransactScene: StateMachine {
   func setState(_ state: TransactState) {


      switch state {
      case .initial:
         break
      case .loadProfilError:
         break
      case .loadTransactionsError:
         break
      case .loadTokensSuccess:
         viewModels.userSearchTextField.set_hidden(false)
      case .loadTokensError:
         viewModels.userSearchTextField.set_hidden(true)
      case .loadBalanceSuccess(let balance):
         viewModels.balanceInfo.models.down.label.set_text(String(balance))
      case .loadBalanceError:
         print("balance not loaded")
      case .loadUsersListSuccess(let users):
         presentFoundUsers(users: users)
      case .loadUsersListError:
         viewModels.foundUsersList.set_hidden(true)
      case .presentFoundUser(let users):
         viewModels.foundUsersList.set_hidden(true)
         presentFoundUsers(users: users)
      case .presentUsers(let users):
         viewModels.foundUsersList.set_hidden(true)
         presentFoundUsers(users: users)
      case .listOfFoundUsers(let users):
         presentFoundUsers(users: users)
      case .userSelectedSuccess(let foundUser, let index):

         if case .userSelectedSuccess = currentState  {
            viewModels.userSearchTextField.set_hidden(false)
            viewModels.foundUsersList.set_hidden(true)
            currentState = .initial
            return
         }

         UIView.animate(withDuration: 0.5) {

            self.setToInitialCondition()
            self.clearFields()

            self.viewModels.foundUsersList.set(.removeAllExceptIndex(index))

            let fullName = foundUser.name + " " + foundUser.surname
            self.viewModels.userSearchTextField.set_hidden(true)
            self.viewModels.transactInputViewModel.set_hidden(false)
            self.viewModels.sendButton.set_hidden(false)
            self.viewModels.reasonTextView.set_hidden(false)
            self.view.layoutIfNeeded()
         }

      case .userSearchTFDidEditingChangedSuccess:
         hideHUD()
      case .sendCoinSuccess(let tuple):
         viewModels.transactionStatusView.start()
         guard
            let superview = view.superview?.superview?.superview?.superview?.superview
         else { return }

         let input = StatusViewInput(baseView: superview,
                                     sendCoinInfo: tuple.1,
                                     username: tuple.0)
         viewModels.transactionStatusView.sendEvent(\.presentOnScene, input)
         setToInitialCondition()
      case .sendCoinError:
         presentAlert(text: "Не могу послать деньгу")
      case .coinInputSuccess(let text, let isCorrect):
         viewModels.transactInputViewModel.textField.set(.text(text))
         if isCorrect {
            viewModels.transactInputViewModel.setState(.normal)
            viewModels.sendButton.set(Design.state.button.default)
         } else {
            viewModels.transactInputViewModel.setState(.noInput)
            viewModels.transactInputViewModel.textField.set(.text(text))
            viewModels.sendButton.set(Design.state.button.inactive)
         }
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
      viewModels.sendButton.set(.hidden(true))
      viewModels.reasonTextView.set(.hidden(true))
   }

   func presentFoundUsers(users: [FoundUser]) {
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
