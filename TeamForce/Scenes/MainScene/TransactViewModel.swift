//
//  TransactViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.07.2022.
//

import UIKit

struct TransactViewEvent: InitProtocol {}

final class TransactViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{
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
   // FIX: change to UITextView
   private lazy var reasonTextView = TextViewModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder(Texts.title.reasonPlaceholder))
      .set(.backColor(UIColor.clear))
      .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
      .set(.borderWidth(1.0))
      .set(.font(Design.font.body1))
      .set(.height(200))
      .set(.hidden(true))
    

   // MARK: - Services
    
   private lazy var apiModel = SearchUserApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorage = StringStorageWorker(engine: Asset.service.safeStringStorage)
   private lazy var sendCoinApiModel = SendCoinApiWorker(apiEngine: Asset.service.apiEngine)

   private lazy var foundUsers: [FoundUser] = []
   private lazy var tokens: (token: String, csrf: String) = ("", "")
   private lazy var recipientID: Int = 0
    
   private lazy var coinInputParser = CoinInputCheckerModel()
   private lazy var reasonInputParser = ReasonCheckerModel()
   private lazy var correctCoinInput: Bool = false
   private lazy var correctReasonInput: Bool = false

   // MARK: - Start

   override func start() {

      configure()

      weak var wS = self

      userSearchModel
         .onEvent(\.didEditingChanged)
         .onSuccess { _ in
            wS?.hideHUD()
         }
         .doNext(usecase: IsEmpty())
         .onSuccess { _ in
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

      tableModel.onEvent(\.didSelectRow) { index in
         guard let self = wS else { return }
         //
         self.recipientID = self.foundUsers[index].userId
         let fullName = self.foundUsers[index].name + " " + self.foundUsers[index].surname
         self.userSearchModel.set(.text(fullName))
         self.tableModel.set(.hidden(true))
         self.transactInputViewModel.set(.hidden(false))
         self.sendButton.set(.hidden(false))
         self.reasonTextView.set(.hidden(false))
      }

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
           let amount = self.transactInputViewModel.textField.view.text
        else { return nil }
        return SendCoinRequest(token: self.tokens.token,
                        csrfToken: self.tokens.csrf,
                        recipient: self.recipientID,
                        amount:  amount,
                        reason: self.reasonTextView.view.text)
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
