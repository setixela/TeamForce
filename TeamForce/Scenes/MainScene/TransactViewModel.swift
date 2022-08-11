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
   Interactable
{
   typealias State = StackState

   var eventsStore: TransactViewEvent = .init()

   // MARK: - View Models

   private lazy var digitalThanksTitle = Design.label.headline4
      .set(.text(Text.title.make(\.digitalThanks)))
      .set(.numberOfLines(1))
      .set(.alignment(.left))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

   private lazy var userSearchModel = TextFieldModel()
      .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
      .set(.height(48))
      .set(.placeholder(Text.title.make(\.chooseRecipient)))
      .set(.hidden(true))
      .set(.padding(.init(top: 0, left: 16, bottom: 0, right: 16)))

   private lazy var transactInputViewModel = TransactInputViewModel<Design>()
      .set(.leftCaptionText(Text.title.make(\.sendThanks)))
      .set(.rightCaptionText(Text.title.make(\.availableThanks)))
      .set(.hidden(true))

   private lazy var tableModel = TableViewModel()
      .set(.borderColor(.gray))
      .set(.borderWidth(1))
      .set(.cornerRadius(Design.Parameters.cornerRadius))
      .set(.hidden(true))

   private lazy var sendButton = Design.button.default
      .set(Design.State.button.inactive)
      .set(.title(Text.button.make(\.sendButton)))
      .set(.hidden(true))

   private lazy var reasonTextView = TextViewModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder(Texts.title.reasonPlaceholder))
      .set(.backColor(UIColor.clear))
      .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
      .set(.borderWidth(1.0))
      .set(.font(Design.font.body1))
      .set(.height(200))
      .set(.hidden(true))

   private lazy var transactionStatusView = TransactionStatusViewModel<Asset>()

   // MARK: - Interactor

   lazy var business = TransactInteractor<Asset>()

   // MARK: - Start

   override func start() {
      configure()

      weak var wS = self

      business
         .onOutput(\.tokensLoaded) {
            wS?.userSearchModel.set(.hidden(false))
         }
      business
         .onOutput(\.balanceLoaded) { balance in
            wS?.transactInputViewModel
               .set(.rightCaptionText(Text.title.make(\.availableThanks) + " " +
                     String(balance.distr.amount)))
         }
         .onFailure(\.loadBalance) {
            print("balance not loaded")
         }

      business
         .onOutput(\.usersFound) { result in
            wS?.presentFoundUsers(users: result)
         }
         .onFailure(\.userSearch) {
            print("Search user API Error")
         }

      userSearchModel
         .onEvent(\.didEditingChanged)
         .onSuccess {
            wS?.hideHUD()
         }
         .doNext(usecase: IsNotEmpty())
         .onSuccess { text in
            wS?.tableModel.set(.hidden(true))
            wS?.business.sendInput(\.searchUser, payload: text)
         }

      sendButton
         .onEvent(\.didTap)
         .doMap {
            wS?.transactInputViewModel.textField.view.text
         }
         .onSuccess { amount in
            let reason = wS?.reasonTextView.view.text ?? ""
            wS?.business.sendInput(\.sendCoins, payload: (amount, reason))
         }
         .onFail {
            print("No amount")
         }

      business
         .onOutput(\.coinsSended) { tuple in
            wS?.transactionStatusView.start()
            guard
               let superview = wS?.view.superview?.superview?.superview?.superview?.superview
            else { return }
            let input = StatusViewInput(baseView: superview,
                                        sendCoinInfo: tuple.info,
                                        username: tuple.recipient)
            wS?.transactionStatusView.sendEvent(\.presentOnScene, input)
            wS?.setToInitialCondition()
         }
         .onFailure(\.sendCoinRequest) { text in
            wS?.presentAlert(text: "Не могу послать деньгу")
         }

      tableModel
         .onEvent(\.didSelectRow) { index in
            wS?.business.sendInput(\.mapIndexToUser, payload: index)
         }
// бесшовный переход
      business
         .onOutput(\.userMapped) { foundUser in
            let fullName = foundUser.name + " " + foundUser.surname
            wS?.userSearchModel.set(.text(fullName))
            wS?.tableModel.set(.hidden(true))
            wS?.transactInputViewModel.set(.hidden(false))
            wS?.sendButton.set(.hidden(false))
            wS?.reasonTextView.set(.hidden(false))
         }

      configureInputParsers()
      business.start()
   }

   func configure() {
      set(.axis(.vertical))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set(.spacing(8))
      set(.models([
         digitalThanksTitle,
         userSearchModel,
         transactInputViewModel,
         reasonTextView,
         sendButton,
         tableModel,
         Spacer(),
      ]))
   }

   private func setToInitialCondition() {
      userSearchModel.set(.text(""))
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

      var correctCoinInput = false
      var correctReasonInput = false

      transactInputViewModel.textField
         .onEvent(\.didEditingChanged) { text in
            wS?.business.sendInput(\.parseCoinInput, payload: text)
         }
      // разрыв ((
      business
         .onOutput(\.coinInputParsed) {
            wS?.transactInputViewModel.textField.set(.text($0))
            correctCoinInput = true
            if correctReasonInput == true {
               wS?.sendButton.set(Design.State.button.default)
            }
         }
         .onFailure(\.coinInputError) { (text: String) in
            wS?.transactInputViewModel.textField.set(.text(text))
            wS?.sendButton.set(Design.State.button.inactive)
         }

      reasonTextView
         .onEvent(\.didEditingChanged) {
            wS?.business.sendInput(\.parseReasonInput, payload: $0)
         }
      // разрыв ((
      business
         .onOutput(\.reasonInputParsed) {
            wS?.reasonTextView.set(.text($0))
            correctReasonInput = true
            if correctCoinInput == true {
               wS?.sendButton.set(Design.State.button.default)
            }
         }
         .onFailure(\.reasonInputError) {
            wS?.reasonTextView.set(.text($0))
            correctReasonInput = false
            wS?.sendButton.set(Design.State.button.inactive)
         }

   }
}
