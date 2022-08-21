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

   private lazy var viewModels = TransactViewModels<Asset>()

   lazy var scenario = TransactScenario(
      works: TransactWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: TransactScenarioEvents(
         userSearchTXTFLDBeginEditing: viewModels.userSearchTextField.onEvent(\.didBeginEditing),
         userSearchTFDidEditingChanged: viewModels.userSearchTextField.onEvent(\.didEditingChanged),
         userSelected: viewModels.tableModel.onEvent(\.didSelectRow),
         sendButtonEvent: viewModels.sendButton.onEvent(\.didTap),
         transactInputChanged: viewModels.transactInputViewModel.textField.onEvent(\.didEditingChanged),
         reasonInputChanged: viewModels.reasonTextView.onEvent(\.didEditingChanged)
      )
   )

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
      set_spacing(8)
      set_arrangedModels([
         viewModels.userSearchTextField,
         viewModels.transactInputViewModel,
         viewModels.reasonTextView,
         viewModels.sendButton,
         viewModels.tableModel,
         Spacer(),
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
      viewModels.sendButton.set(.hidden(true))
      viewModels.reasonTextView.set(.hidden(true))
   }

   private func clearFields() {
      viewModels.userSearchTextField.set_text("")
      viewModels.transactInputViewModel.textField.set_text("")
      viewModels.reasonTextView.set(.text(""))
   }
}

extension TransactScene: SceneStateProtocol {
   func setState(_ state: TransactState) {
      switch state {
      case .loadProfilError:
         break
      case .loadTransactionsError:
         break
      case .loadTokensSuccess:
         viewModels.userSearchTextField.set_hidden(false)
      case .loadTokensError:
         viewModels.userSearchTextField.set_hidden(true)
      case .loadBalanceSuccess(let balance):
         viewModels.transactInputViewModel.set(.rightCaptionText(Text.title.availableThanks +
               " " + String(balance)))
      case .loadBalanceError:
         print("balance not loaded")
      case .loadUsersListSuccess(let users):
         presentFoundUsers(users: users)
      case .loadUsersListError:
         viewModels.tableModel.set_hidden(true)
      case .presentFoundUser(let users):
         viewModels.tableModel.set_hidden(true)
         presentFoundUsers(users: users)
      case .presentUsers(let users):
         viewModels.tableModel.set_hidden(true)
         presentFoundUsers(users: users)
      case .listOfFoundUsers(let users):
         presentFoundUsers(users: users)
      case .userSelectedSuccess(let foundUser):
         clearFields()
         setToInitialCondition()
         let fullName = foundUser.name + " " + foundUser.surname
         viewModels.userSearchTextField.set(.text(fullName))
         viewModels.tableModel.set_hidden(true)
         viewModels.transactInputViewModel.set_hidden(false)
         viewModels.sendButton.set_hidden(false)
         viewModels.reasonTextView.set_hidden(false)
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
            viewModels.sendButton.set(Design.state.button.default)
         } else {
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
   }
}

private extension TransactScene {
   func hideHUD() {
      viewModels.transactInputViewModel.set(.hidden(true))
      viewModels.sendButton.set(.hidden(true))
      viewModels.reasonTextView.set(.hidden(true))
   }

   func presentFoundUsers(users: [FoundUser]) {
      let found = users.map { $0.name + " " + $0.surname }
      let cellModels = found.map { name -> LabelCellModel in
         let cellModel = LabelCellModel()
         cellModel.set(.text(name))
         return cellModel
      }
      viewModels.tableModel.set(.models(cellModels))
      viewModels.tableModel.set(.hidden(found.isEmpty ? true : false))
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
