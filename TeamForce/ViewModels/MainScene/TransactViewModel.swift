//
//  TransactViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.07.2022.
//

import UIKit

final class TransactViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
    Assetable,
    Stateable
{
    var text: Asset.Text = .init() // Move to self.design.text......
    var icon: Asset.Design.Icon = .init()

    // MARK: - View Models

    private lazy var digitalThanksTitle = Design.label.headline4
        .set(.text(text.title.make(\.digitalThanks)))
        .set(.numberOfLines(1))
        .set(.alignment(.left))
        .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

    private lazy var userSearchModel = TextFieldModel()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .set(.placeholder(text.title.make(\.chooseRecipient)))
        .set(.hidden(true))
        .set(.padding(.init(top: 0, left: 16, bottom: 0, right: 16)))

//    private lazy var pickerModel = PickerViewModel()
//        .set(.borderColor(.gray))
//        .set(.borderWidth(1))
//        .set(.cornerRadius(Design.Parameters.cornerRadius))
//        .set(.height(200))
//        .set(.hidden(true))

    private lazy var transactInputViewModel = TransactInputViewModel<Design>()
        .set(.leftCaptionText(text.title.make(\.sendThanks)))
        .set(.rightCaptionText(text.title.make(\.availableThanks)))
        .set(.hidden(true))

    private lazy var tableModel = TableViewModel()
        .set(.borderColor(.gray))
        .set(.borderWidth(1))
        .set(.cornerRadius(Design.Parameters.cornerRadius))
        .set(.hidden(true))

    // MARK: - Services

    private lazy var apiModel = SearchUserApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var safeStringStorage = StringStorageModel(engine: Asset.service.safeStringStorage)

    private lazy var foundUsers: [String] = []
    private lazy var tokens: (token: String, csrf: String) = ("", "")

    // MARK: - Start

    override func start() {
        set(.axis(.vertical))
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.spacing(8))
        set(.models([
            digitalThanksTitle,
            //    selectPeriodViewModel,
            userSearchModel,
           // pickerModel,
            transactInputViewModel,
            tableModel,
            Spacer()
        ]))

        weak var wS = self

        userSearchModel.onEvent(\.didEditingChanged) { text in
            guard let self = wS else { return }
            self.transactInputViewModel.set(.hidden(true))

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

            self.userSearchModel.set(.text(self.foundUsers[index]))
            self.tableModel.set(.hidden(true))
            self.transactInputViewModel.set(.hidden(false))
        }

        let cellModels = (0 ... 100).map { index -> LabelCellModel in
            let cellModel = LabelCellModel()
            cellModel.set(.text(String(index)))
            return cellModel
        }
        tableModel.set(.models(cellModels))
    }
}

extension TransactViewModel {
    func searchUser(_ request: SearchUserRequest) {
        apiModel
            .onEvent(\.success) { [weak self] result in
                let found = result.map { $0.name + " " + $0.surname }
                self?.foundUsers = found
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

    private lazy var textField = TextFieldModel()
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
