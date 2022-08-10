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
   Assetable
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

   // MARK: - Services

   private lazy var apiModel = SearchUserApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorage = StringStorageWorker(engine: Asset.service.safeStringStorage)
   private lazy var sendCoinApiModel = SendCoinApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var loadBalanceUseCase = Asset.apiUseCase.loadBalance.work()

   private lazy var foundUsers: [FoundUser] = []
   private lazy var tokens: (token: String, csrf: String) = ("", "")
   private lazy var recipientID: Int = 0
   private lazy var recipientUsername: String = ""

   private lazy var coinInputParser = CoinInputCheckerModel()
   private lazy var reasonInputParser = ReasonCheckerModel()
   private lazy var correctCoinInput: Bool = false
   private lazy var correctReasonInput: Bool = false

   // MARK: - Start

   override func start() {
      configure()

      weak var wS = self

      loadBalanceUseCase
         .doAsync()
         .onSuccess { balance in
            wS?.transactInputViewModel
               .set(.rightCaptionText(Text.title.make(\.availableThanks) + " " +
                     String(balance.distr.amount)))
         }
         .onFail {
            print("balance not loaded")
         }

      userSearchModel
         .onEvent(\.didEditingChanged)
         .onSuccess {
            wS?.hideHUD()
         }
         .doNext(usecase: IsEmpty())
         .onSuccess {
            wS?.tableModel.set(.hidden(true))
         }
         .doMap { text in
            guard let self = wS else { return nil }

            return SearchUserRequest(
               data: text,
               token: self.tokens.token,
               csrfToken: self.tokens.csrf
            )
         }
         .doNext(work: apiModel.work)
         .onSuccess { result in
            wS?.presentFoundUsers(users: result)
         }.onFail {
            print("Search user API Error")
         }

      sendButton
         .onEvent(\.didTap)
         .doInput {
            wS?.makeSendCoinRequest()
         }
         .onFail {
            print("SendCointRequest init error")
         }
         .doNext(worker: sendCoinApiModel)
         .onSuccess {
            wS?.transactionStatusView.start()
            // FIX: super puper view :)
            guard
               let superview = wS?.view, // .superview?.superview?.superview?.superview?.superview,
               let username = wS?.recipientUsername,
               let info = wS?.makeSendCoinRequest()
            else { return }
            let input = StatusViewInput(baseView: superview,
                                        sendCoinInfo: info,
                                        username: username)
            wS?.transactionStatusView.sendEvent(\.presentOnScene, input)
            wS?.setToInitialCondition()
         }.onFail { (text: String) in
            wS?.presentAlert(text: text)
         }

      safeStringStorage
         .doAsync("token")
         .onSuccess {
            wS?.tokens.token = $0
         }
         .onFail {
            print("token load failed")
         }
         .doInput("csrftoken")
         .doNext(worker: safeStringStorage)
         .onSuccess {
            wS?.tokens.csrf = $0
            wS?.userSearchModel.set(.hidden(false))
         }
         .onFail {
            print("csrftoken load failed")
         }

      tableModel
         .onEvent(\.didSelectRow)
         .doMap { index in
             wS?.foundUsers[index.row]
         }.onSuccess { foundUser in
            let fullName = foundUser.name + " " + foundUser.surname
            wS?.recipientUsername = foundUser.tgName
            wS?.recipientID = foundUser.userId

            wS?.userSearchModel.set(.text(fullName))
            wS?.tableModel.set(.hidden(true))
            wS?.transactInputViewModel.set(.hidden(false))
            wS?.sendButton.set(.hidden(false))
            wS?.reasonTextView.set(.hidden(false))
         }

      configureInputParsers()
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
      correctCoinInput = false
      correctReasonInput = false
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

   func makeSendCoinRequest() -> SendCoinRequest? {
      guard
         let amount = transactInputViewModel.textField.view.text
      else { return nil }
      return SendCoinRequest(token: tokens.token,
                             csrfToken: tokens.csrf,
                             recipient: recipientID,
                             amount: amount,
                             reason: reasonTextView.view.text)
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
      foundUsers = users
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

      transactInputViewModel.textField
         .onEvent(\.didEditingChanged)
         .doNext(worker: coinInputParser)
         .onSuccess {
            wS?.transactInputViewModel.textField.set(.text($0))
            wS?.correctCoinInput = true
            if wS?.correctReasonInput == true {
               wS?.sendButton.set(Design.State.button.default)
            }
         }
         .onFail { (text: String) in
            wS?.correctCoinInput = false
            wS?.transactInputViewModel.textField.set(.text(text))
            wS?.sendButton.set(Design.State.button.inactive)
         }

      reasonTextView
         .onEvent(\.didEditingChanged)
         .doNext(worker: reasonInputParser)
         .onSuccess {
            wS?.reasonTextView.set(.text($0))
            wS?.correctReasonInput = true
            if wS?.correctCoinInput == true {
               wS?.sendButton.set(Design.State.button.default)
            }
         }
         .onFail { (text: String) in
            wS?.reasonTextView.set(.text(text))
            wS?.correctReasonInput = false
            wS?.sendButton.set(Design.State.button.inactive)
         }
   }
}
