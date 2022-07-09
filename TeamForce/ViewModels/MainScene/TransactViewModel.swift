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

    private lazy var pickerModel = PickerViewModel()
        .set(.borderColor(.gray))
        .set(.borderWidth(1))
        .set(.cornerRadius(Design.Parameters.cornerRadius))
        .set(.height(200))
        .set(.hidden(true))

    private lazy var transactInputViewModel = TransactInputViewModel()
        .set(.hidden(true))

    private lazy var apiModel = SearchUserApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var safeStringStorage = TokenStorageModel(engine: Asset.service.safeStringStorage)

    private lazy var foundUsers: [String] = []
    private lazy var tokens: (token: String, csrf: String) = ("","")

    override func start() {
        set(.axis(.vertical))
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.spacing(8))
        set(.models([
            digitalThanksTitle,
            //    selectPeriodViewModel,
            userSearchModel,
            pickerModel,
            transactInputViewModel,
            Spacer()
        ]))

        weak var wS = self

        userSearchModel.onEvent(\.didEditingChanged) { text in
            guard let self = wS else { return }
            wS?.transactInputViewModel.set(.hidden(true))

            guard !text.isEmpty else {
                self.pickerModel.set(.hidden(true))
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
                    .sendEvent(\.requestValue, "csrftoken")
            }
            .sendEvent(\.requestValue, "token")

        pickerModel.onEvent(\.didSelectRow) { index in
            guard let self = wS else { return }

            self.userSearchModel.set(.text(self.foundUsers[index]))
            self.pickerModel.set(.hidden(true))
            self.transactInputViewModel.set(.hidden(false))
        }
    }
}

extension TransactViewModel {
    func searchUser(_ request: SearchUserRequest) {
        apiModel
            .onEvent(\.success) { [weak self] result in
                let found = result.map { $0.name + " " + $0.surname }
                self?.foundUsers = found
                self?.pickerModel.set(.items(found))
                self?.pickerModel.set(.hidden(found.isEmpty ? true : false))
            }
            .sendEvent(\.request, request)
    }
}

final class TransactInputViewModel: BaseViewModel<UIStackView> {
    override func start() {
        set(.alignment(.fill),
            .distribution(.fill),
            .axis(.vertical),
            .spacing(0),
            .height(118),
            .backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
    }
}

extension TransactInputViewModel: Stateable {}
