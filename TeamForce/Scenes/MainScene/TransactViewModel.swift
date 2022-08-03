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
      .set(.title(Text.button.make(\.sendButton)))
      .set(.hidden(true))
   // FIX: change to UITextView
   private lazy var reasonTextField = TextFieldModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder("Обоснование"))
      .set(.backColor(UIColor.clear))
      .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
      .set(.borderWidth(1.0))
      .set(.hidden(true))
      .set(.clearButtonMode(UITextField.ViewMode.never))

   // MARK: - Services

   private lazy var apiModel = SearchUserApiWorker(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorage = StringStorageWorker(engine: Asset.service.safeStringStorage)
   private lazy var sendCoinApiModel = SendCoinApiModel(apiEngine: Asset.service.apiEngine)

   private lazy var foundUsers: [FoundUser] = []
   private lazy var tokens: (token: String, csrf: String) = ("", "")
   private lazy var recipientID: Int = 0

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
         .onEvent(\.didTap) {
            wS?.sendCoinApiModel
               .onEvent(\.success) { _ in
                  wS?.userSearchModel.set(.text(""))
                  wS?.transactInputViewModel.set(.hidden(true))
                  wS?.transactInputViewModel.textField.set(.text(""))
                  wS?.sendButton.set(.hidden(true))
                  wS?.reasonTextField.set(.text(""))
                  wS?.reasonTextField.set(.hidden(true))
               }
               .onEvent(\.error) {
                  print("coin sending error: ")
                  print($0)
               }
               .sendEvent(\.request, SendCoinRequest(token: self.tokens.token,
                                                     csrfToken: self.tokens.csrf,
                                                     recipient: self.recipientID,
                                                     amount: self.transactInputViewModel.textField.view.text ?? "0",
                                                     reason: self.reasonTextField.view.text ?? "thanks"))
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
         self.reasonTextField.set(.hidden(false))
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
         reasonTextField,
         sendButton,
         tableModel,
         Spacer(),
      ]))
   }
}

private extension TransactViewModel {
   func hideHUD() {
      transactInputViewModel.set(.hidden(true))
      sendButton.set(.hidden(true))
      reasonTextField.set(.hidden(true))
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

enum TransactInputState {
   case leftCaptionText(String)
   case rightCaptionText(String)
}

final class TransactInputViewModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
   Designable
{
   private lazy var doubleLabel = DoubleLabelModel<Design>()

   internal lazy var textField = TextFieldModel()
      .set(.clearButtonMode(.never))
      .set(.font(Design.font.headline2))
      .set(.height(72))
      .set(.placeholder("0"))
      .set(.padding(.init(top: 0, left: 16, bottom: 0, right: 16)))
      .set(.backColor(Design.color.background1))

   override func start() {
      set(.alignment(.fill),
          .distribution(.fill),
          .axis(.vertical),
          .spacing(0),
          .height(118),
          .backColor(Design.color.background1),
          .models([
             doubleLabel,
             textField,
          ]))
   }
}

extension TransactInputViewModel: Stateable2 {
   typealias State = StackState

   func applyState(_ state: TransactInputState) {
      switch state {
      case .leftCaptionText(let string):
         doubleLabel.labelLeft.set(.text(string))
      case .rightCaptionText(let string):
         doubleLabel.labelRight.set(.text(string))
      }
   }
}
