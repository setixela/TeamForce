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
    
    private lazy var reasonTextView = TextViewModel()
        .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
        .set(.placeholder(Texts.title.reasonPlaceholder))
        .set(.backColor(UIColor.clear))
        .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
        .set(.borderWidth(1.0))
        .set(.font(Design.font.body1))
        .set(.hidden(true))
        .set(.height(200))
    
    private lazy var transactionStatusView = TransactionStatusViewModel<Asset>()
        .set(.cornerRadius(GlobalParameters.cornerRadius))
    // MARK: - Services

    private lazy var apiModel = SearchUserApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var safeStringStorage = StringStorageModel(engine: Asset.service.safeStringStorage)
    private lazy var sendCoinApiModel = SendCoinApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var balanceApiModel = GetBalanceApiModel(apiEngine: Asset.service.apiEngine)

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
        configureInputParsers(wS: wS)
        configureSendButton(wS: wS)
        configureUserSearchModel(wS: wS)
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
                    Spacer()
                ]))
    }
    
    func configureInputParsers(wS: TransactViewModel<Asset>?) {
        wS?.balanceApiModel
            .onEvent(\.success) { balance in
                wS?.transactInputViewModel
                    .set(.rightCaptionText(Text.title.availableThanks + ": " + String(balance.distr.amount)))
            }
            .onEvent(\.error) {
                print($0)
            }
            .sendEvent(\.request, TokenRequest(token: tokens.token))
        
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
           .onEvent(\.error) {
               wS?.correctCoinInput = false
               wS?.transactInputViewModel.textField.set(.text($0))
               wS?.sendButton.set(Design.State.button.inactive)
           }
        
        reasonTextView
            .onEvent(\.didEditingChanged) { [weak self] text in
                self?.reasonInputParser.sendEvent(\.request, text)
                
            }

        reasonInputParser
           .onEvent(\.success) {
               wS?.reasonTextView.set(.text($0))
               wS?.correctReasonInput = true
               if wS?.correctCoinInput == true {
                   wS?.sendButton.set(Design.State.button.default)
               }
           }
           .onEvent(\.error) {
               wS?.reasonTextView.set(.text($0))
               wS?.correctReasonInput = false
               wS?.sendButton.set(Design.State.button.inactive)
           }
    }
    
    private func configureUserSearchModel(wS: TransactViewModel<Asset>?) {
        userSearchModel.onEvent(\.didEditingChanged) { text in
            guard let self = wS else { return }
            self.transactInputViewModel.set(.hidden(true))
            self.sendButton.set(.hidden(true))
            self.reasonTextView.set(.hidden(true))

            guard !text.isEmpty else {
                self.tableModel.set(.hidden(true))
                return
            }

            wS?.searchUser(SearchUserRequest(data: text,
                                             token: self.tokens.token,
                                             csrfToken: self.tokens.csrf))
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
            self.reasonTextView.set(.hidden(false))
        }

        let cellModels = (0 ... 100).map { index -> LabelCellModel in
            let cellModel = LabelCellModel()
            cellModel.set(.text(String(index)))
            return cellModel
        }
        tableModel.set(.models(cellModels))
    }
    
    private func configureSendButton(wS: TransactViewModel<Asset>?) {
        sendButton
            .onEvent(\.didTap) {
                wS?.sendCoinApiModel
                    .onEvent(\.success) { _ in
//                        Asset.router?.route(\.transactionStatus, navType: .present, payload: nil)
//                        Asset.router?.route(\.transactionStatus, navType: .present, payload: ())
                        self.transactionStatusView.start()
                        self.transactionStatusView.sendEvent(\.presentOnScene, self.view.superview!.superview!)
                        self.setInitialStateOfView(wS: wS)
                    }
                    .onEvent(\.error) {
                        print("coin sending error: ")
                        let alert = UIAlertController(title: "Ошибка",
                                                      message: $0,
                                                      preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                               comment: "Default action"),
                                                      style: .default))

                        UIApplication.shared.keyWindow?.rootViewController?
                            .present(alert, animated: true, completion: nil)
                    }
                    .sendEvent(\.request, SendCoinRequest(token: self.tokens.token,
                                                          csrfToken: self.tokens.csrf,
                                                          recipient: self.recipientID,
                                                          amount: self.transactInputViewModel.textField.view.text!,
                                                          reason: self.reasonTextView.view.text!))
            }
    }
    
    private func setInitialStateOfView(wS: TransactViewModel<Asset>?) {
        wS?.userSearchModel.set(.text(""))
        wS?.transactInputViewModel.set(.hidden(true))
        wS?.transactInputViewModel.textField.set(.text(""))
        wS?.sendButton.set(.hidden(true))
        wS?.reasonTextView.set(.text(""))
        wS?.reasonTextView.set(.hidden(true))
        wS?.sendButton.set(Design.State.button.inactive)
        wS?.correctCoinInput = false
        wS?.correctReasonInput = false
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
