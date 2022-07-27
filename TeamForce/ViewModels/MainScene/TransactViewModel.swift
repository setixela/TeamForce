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

//    private lazy var pickerModel = PickerViewModel()
//        .set(.borderColor(.gray))
//        .set(.borderWidth(1))
//        .set(.cornerRadius(Design.Parameters.cornerRadius))
//        .set(.height(200))
//        .set(.hidden(true))

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
    //FIX: change to UITextView
    private lazy var reasonTextField = TextFieldModel()
        .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
        .set(.placeholder("Обоснование"))
        .set(.backColor(UIColor.clear))
        .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
        .set(.borderWidth(1.0))
        .set(.hidden(true))
        .set(.clearButtonMode(UITextField.ViewMode.never))

    // MARK: - Services

    private lazy var apiModel = SearchUserApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var safeStringStorage = StringStorageModel(engine: Asset.service.safeStringStorage)
    private lazy var sendCoinApiModel = SendCoinApiModel(apiEngine: Asset.service.apiEngine)

    private lazy var foundUsers: [FoundUser] = []
    private lazy var tokens: (token: String, csrf: String) = ("", "")
    private lazy var recipientID: Int = 0
    
    private lazy var coinInputParser = CoinCheckerModel()
    private lazy var reasonInputParser = ReasonCheckerModel()
    
    private lazy var correctCoinInput: Bool = false
    private lazy var correctReasonInput: Bool = false

    // MARK: - Start

    override func start() {
        configure()
        
        weak var wS = self
        
        userSearchModel.onEvent(\.didEditingChanged) { text in
            guard let self = wS else { return }
            self.transactInputViewModel.set(.hidden(true))
            self.sendButton.set(.hidden(true))
            self.reasonTextField.set(.hidden(true))

            guard !text.isEmpty else {
                self.tableModel.set(.hidden(true))
                return
            }

            wS?.searchUser(SearchUserRequest(data: text,
                                             token: self.tokens.token,
                                             csrfToken: self.tokens.csrf))
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
            .onEvent(\.responseValue) { token in
                wS?.safeStringStorage
                    .onEvent(\.responseValue) { csrf in
                        wS?.tokens = (token, csrf)
                        wS?.userSearchModel.set(.hidden(false))
                    }
                    .sendEvent(\.requestValueForKey, "csrftoken")
            }
            .sendEvent(\.requestValueForKey, "token")

        tableModel.onEvent(\.didSelectRow) { index in
            guard let self = wS else { return }
            self.recipientID = self.foundUsers[index].userId
            let fullName = self.foundUsers[index].name + " " + self.foundUsers[index].surname
            self.userSearchModel.set(.text(fullName))
            self.tableModel.set(.hidden(true))
            self.transactInputViewModel.set(.hidden(false))
            self.sendButton.set(.hidden(false))
            self.reasonTextField.set(.hidden(false))
        }

        let cellModels = (0 ... 100).map { index -> LabelCellModel in
            let cellModel = LabelCellModel()
            cellModel.set(.text(String(index)))
            return cellModel
        }
        tableModel.set(.models(cellModels))
        
        transactInputViewModel.textField
            .onEvent(\.didEditingChanged) { [weak self] text in
                self?.coinInputParser.sendEvent(\.request, text)
            }
        
        coinInputParser
           .onEvent(\.success) {
               wS?.transactInputViewModel.textField.set(.text($0))
               wS?.correctCoinInput = true
               if wS?.correctReasonInput == true {
                   wS?.sendButton.set(Design.State.button.default)
               }
           }
           .onEvent(\.error) {_ in
               wS?.correctCoinInput = false
               wS?.transactInputViewModel.textField.set(.text(""))
               wS?.sendButton.set(Design.State.button.inactive)
           }
        
        reasonTextField
            .onEvent(\.didEditingChanged) { [weak self] text in
                self?.reasonInputParser.sendEvent(\.request, text)
            }
        
        reasonInputParser
           .onEvent(\.success) {
               wS?.reasonTextField.set(.text($0))
               wS?.correctReasonInput = true
               if wS?.correctCoinInput == true {
                   wS?.sendButton.set(Design.State.button.default)
               }
           }
           .onEvent(\.error) {
               wS?.reasonTextField.set(.text($0))
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
                    reasonTextField,
                    sendButton,
                    tableModel,
                    Spacer()
                ]))
    }
}

extension TransactViewModel {
    func searchUser(_ request: SearchUserRequest) {
        apiModel
            .onEvent(\.success) { [weak self] result in
                let found = result.map { $0.name + " " + $0.surname }
                self?.foundUsers = result
                let cellModels = found.map { name -> LabelCellModel in
                    let cellModel = LabelCellModel()
                    cellModel.set(.text(name))
                    return cellModel
                }
                self?.tableModel.set(.models(cellModels))
                self?.tableModel.set(.hidden(found.isEmpty ? true : false))
            }
            .sendEvent(\.request, request)
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
