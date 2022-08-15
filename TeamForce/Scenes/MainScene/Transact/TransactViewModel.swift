//
//  TransactViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.07.2022.
//

import ReactiveWorks
import UIKit

struct TransactViewEvent: InitProtocol {}

final class TransactViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable,
   WorkableModel
{
   typealias State = StackState

   var eventsStore: TransactViewEvent = .init()

   // MARK: - View Models

   private lazy var digitalThanksTitle = Design.label.headline4
      .set_text(Text.title.digitalThanks)
      .set_numberOfLines(1)
      .set_alignment(.left)
      .set_padding(.init(top: 22, left: 0, bottom: 26, right: 0))

   private lazy var userSearchTextField = TextFieldModel<Design>()
      .set_backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08))
      .set_height(48)
      .set_placeholder(Text.title.chooseRecipient)
      .set_hidden(true)
      .set_padding(.init(top: 0, left: 16, bottom: 0, right: 16))

   private lazy var transactInputViewModel = TransactInputViewModel<Design>()
      .set(.leftCaptionText(Text.title.sendThanks))
      .set(.rightCaptionText(Text.title.availableThanks))
      .set_hidden(true)

   private lazy var tableModel = TableViewModel()
      .set_borderColor(.gray)
      .set_borderWidth(1)
      .set_cornerRadius(Design.params.cornerRadius)
      .set_hidden(true)

   private lazy var sendButton = Design.button.default
      .set(Design.state.button.inactive)
      .set_title(Text.button.sendButton)
      .set_hidden(true)

   private lazy var reasonTextView = TextViewModel<Design>()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder(TextBuilder.title.reasonPlaceholder))
      .set(.font(Design.font.body1))
      .set_backColor(UIColor.clear)
      .set_borderColor(.lightGray.withAlphaComponent(0.4))
      .set_borderWidth(1.0)

      .set_height(200)
      .set_hidden(true)

   private lazy var transactionStatusView = TransactionStatusViewModel<Asset>()

   // MARK: - Interactor

   lazy var works = TransactWorks<Asset>()

   // MARK: - Start

   override func start() {
      configure()

      weak var wS = self

      let store = works.store

      // load tokens, then load balance, then load 10 user list
      works.loadTokens
         .doAsync()
         .onSuccess {
            wS?.userSearchTextField.set_hidden(false)
         }
         .onFail {
            wS?.userSearchTextField.set_hidden(true)
         }
         // then load balance
         .doNext(work: works.loadBalance)
         .onSuccess {
            wS?.transactInputViewModel.set(.rightCaptionText(
               Text.title.availableThanks + " " + String($0.distr.amount)
            ))
         }
         .onFail {
            print("balance not loaded")
         }
         // then break data
         .doInput(())
         // then load 10 user list
         .doNext(work: works.getUserList)
         .onSuccess {
            wS?.presentFoundUsers(users: $0)
         }
         .onFail {
            wS?.tableModel.set_hidden(true)
         }

      // on input event, then check input is not empty, then search user
      userSearchTextField
         .onEvent(\.didEditingChanged)
         .onSuccess {
            wS?.hideHUD()
         }
         // then check data is not empty
         .doNext(usecase: IsEmpty())
         .onSuccess {
            wS?.tableModel.set_hidden(true)
            wS?.works.getUserList
               .doAsync()
               .onSuccess {
                  wS?.presentFoundUsers(users: $0)
               }
         }
         // then search user
         .doNext(work: works.searchUser)
         .onSuccess {
            wS?.presentFoundUsers(users: $0)
         }
         .onFail {
            print("Search user API Error")
         }

      sendButton
         .onEvent(\.didTap)
         .doInput {
            store.inputAmountText
         } // TODO: - Сделать по аналогии Zip
         .doMap { amount in
            (amount, store.inputReasonText)
         }
         .doNext(work: works.sendCoins)
         .onSuccess { tuple in
            wS?.transactionStatusView.start()
            guard // ))) значит этому тут не место)) надо придумать механизм
               let superview = wS?.view.superview?.superview?.superview?.superview?.superview
            else { return }
            let input = StatusViewInput(baseView: superview,
                                        sendCoinInfo: tuple.info,
                                        username: tuple.recipient)
            wS?.transactionStatusView.sendEvent(\.presentOnScene, input)
            wS?.setToInitialCondition()
         }
         .onFail {
            wS?.presentAlert(text: "Не могу послать деньгу")
         }

      tableModel
         .onEvent(\.didSelectRow)
         // map index to user
         .doNext(work: works.mapIndexToUser)
         .onSuccess { foundUser in
            let fullName = foundUser.name + " " + foundUser.surname
            wS?.userSearchTextField.set(.text(fullName))
            wS?.tableModel.set_hidden(true)
            wS?.transactInputViewModel.set_hidden(false)
            wS?.sendButton.set_hidden(false)
            wS?.reasonTextView.set_hidden(false)
         }

      configureInputParsers()
   }

   func configure() {
      set_axis(.vertical)
      set_distribution(.fill)
      set_alignment(.fill)
      set_spacing(8)
      set_models([
         digitalThanksTitle,
         userSearchTextField,
         transactInputViewModel,
         reasonTextView,
         sendButton,
         tableModel,
         Spacer(),
      ])
   }

   private func setToInitialCondition() {
      userSearchTextField.set(.text(""))
      transactInputViewModel.set(.hidden(true))
      transactInputViewModel.textField.set(.text(""))
      sendButton.set(.hidden(true))
      reasonTextView.set(.text(""))
      reasonTextView.set(.hidden(true))
   }

   private func presentAlert(text: String) {
      let alert = UIAlertController(title: "Ошибка",
                                    message: text,
                                    preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                    style: .default))

      UIApplication.shared.keyWindow?.rootViewController?
         .present(alert, animated: true, completion: nil)
   }
}

private extension TransactViewModel {
   func hideHUD() {
      transactInputViewModel.set(.hidden(true))
      sendButton.set(.hidden(true))
      reasonTextView.set(.hidden(true))
   }

   func presentFoundUsers(users: [FoundUser]) {
      let found = users.map { $0.name + " " + $0.surname }
      let cellModels = found.map { name -> LabelCellModel in
         let cellModel = LabelCellModel()
         cellModel.set(.text(name))
         return cellModel
      }
      tableModel.set(.models(cellModels))
      tableModel.set(.hidden(found.isEmpty ? true : false))
   }
}

private extension TransactViewModel {
   func configureInputParsers() {
      weak var wS = self

      let store = works.store
      var correctCoinInput = false
      var correctReasonInput = false

      transactInputViewModel.textField
         // on did editing
         .onEvent(\.didEditingChanged)
         // then parse and check input text
         .doNext(work: works.coinInputParsing)
         .onSuccess {
            wS?.transactInputViewModel.textField.set(.text($0))
            correctCoinInput = true
            store.inputAmountText = $0
            if correctReasonInput == true {
               wS?.sendButton.set(Design.state.button.default)
            }
         }
         .onFail { (text: String) in
            store.inputAmountText = ""
            wS?.transactInputViewModel.textField.set(.text(text))
            wS?.sendButton.set(Design.state.button.inactive)
         }

      reasonTextView
         // on did editing
         .onEvent(\.didEditingChanged)
         // then parse and check input text
         .doNext(work: works.reasonInputParsing)
         .onSuccess {
            wS?.reasonTextView.set(.text($0))
            correctReasonInput = true
            store.inputReasonText = $0
            if correctCoinInput == true {
               wS?.sendButton.set(Design.state.button.default)
            }
         }
         .onFail { (text: String) in
            wS?.reasonTextView.set(.text(text))
            correctReasonInput = false
            store.inputReasonText = ""
            wS?.sendButton.set(Design.state.button.inactive)
         }
   }
}
