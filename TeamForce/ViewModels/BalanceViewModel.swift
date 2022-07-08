//
//  BalanceViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import RealmSwift
import UIKit

struct BalanceViewEvent: InitProtocol {}

final class BalanceViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
    Communicable,
    Stateable,
    Assetable
{
    var text: Asset.Text = .init()
    var icon: Asset.Design.Icon = .init()

    var eventsStore: BalanceViewEvent = .init()

    // MARK: - Frame Cells

    private lazy var digitalThanksTitle = Design.label.headline4
        .set(.text(text.title.make(\.digitalThanks)))
        .set(.numberOfLines(1))
        .set(.alignment(.left))
        .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

    private lazy var frameModel = LabelIconHorizontalModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .set(.text(text.title.make(\.selectPeriod)))
        .set(.image(Design.icon.make(\.calendarLine)))

    private lazy var frameModel2 = DoubleLabelPairModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))

    private lazy var leftFrameCell = FrameCellModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.header(text.title.make(\.myAccount)))

    private lazy var rightFrameCell = FrameCellModel<Design>()
        .set(.header(text.title.make(\.leftToSend)))
        .set(.borderWidth(1))
        .set(.borderColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))

    private lazy var frameCellStackModel = StackModel()
        .set(.axis(.horizontal))
        .set(.distribution(.fillEqually))
        .set(.alignment(.center))
        .set(.spacing(8))
        .set(.models([
            leftFrameCell,
            rightFrameCell
        ]))

    private lazy var menuButton = BarButtonModel()
        .sendEvent(\.initWithImage, Design.icon.make(\.sideMenu))

    // MARK: - Services

    private lazy var userProfileApiModel = GetProfileApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var balanceApiModel = GetBalanceApiModel(apiEngine: Asset.service.apiEngine)

    private var balance: Balance?

    override func start() {
        set(.axis(.vertical))
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.models([
            digitalThanksTitle,
            frameModel,
            Spacer(size: 20),
            frameCellStackModel,
            Spacer(size: 8),
            frameModel2,
            Spacer()
        ]))

        weak var weakSelf = self

        guard
            let realm = try? Realm(),
            let token = realm.objects(Token.self).first
        else {
            return
        }

        print(token.token)
        balanceApiModel
            .onEvent(\.success) { balance in
                weakSelf?.setBalance(balance)
            }
            .onEvent(\.error) {
                print($0)
            }
            .sendEvent(\.request, TokenRequest(token: token.token))
    }
}

extension BalanceViewModel {
    private func setBalance(_ balance: Balance) {
        setIncome(balance.income)
        setDistr(balance.distr)

        let frozenSum = balance.income.frozen + balance.distr.frozen
        let cancelledSum = balance.income.cancelled + balance.distr.cancelled

        frameModel2
            .set(.leftPair(text1: "\(text.title.make(\.onAgreement)): ",
                           text2: "\(frozenSum)"))
            .set(.rightPair(text1: "\(text.title.make(\.canceled)): ",
                            text2: "\(cancelledSum)"))
    }

    private func setIncome(_ income: Income) {
        leftFrameCell
            .set(.text(String(income.amount)))
            .set(.caption("\(text.title.make(\.sended)): \(income.sended)"))
    }

    private func setDistr(_ distr: Distr) {
        rightFrameCell
            .set(.text(String(distr.amount)))
            .set(.caption("\(text.title.make(\.sended)): \(distr.sended)"))
    }
}

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

    private lazy var selectPeriodViewModel = LabelIconHorizontalModel<Design>()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .set(.text(text.title.make(\.selectPeriod)))
        .set(.image(Design.icon.make(\.calendarLine)))
        .set(.hidden(false))
        .sendEvent(\.startTapRecognizer)

    private lazy var userSearchModel = TextFieldModel()
        .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
        .set(.height(48))
        .set(.hidden(true))
        .onEvent(\.didEditingChanged) { [weak self] text in

            self?.safeStringStorage
                .onEvent(\.responseValue) { token in
                    self?.safeStringStorage
                        .onEvent(\.responseValue) { csrf in
                            self?.searchUser(SearchUserRequest(data: text, token: token, csrfToken: csrf))
                        }
                        .sendEvent(\.requestValue, "csrftoken")
                }
                .sendEvent(\.requestValue, "token")
        }

    private lazy var pickerModel = PickerViewModel()
        .set(.borderColor(.gray))
        .set(.borderWidth(1))
        .set(.cornerRadius(Design.Parameters.cornerRadius))
        .set(.height(200))

    private lazy var apiModel = SearchUserApiModel(apiEngine: Asset.service.apiEngine)
    private lazy var safeStringStorage = TokenStorageModel(engine: Asset.service.safeStringStorage)

    override func start() {
        set(.axis(.vertical))
        set(.distribution(.fill))
        set(.alignment(.fill))
        set(.spacing(8))
        set(.models([
            digitalThanksTitle,
            selectPeriodViewModel,
            userSearchModel,
            pickerModel,
            Spacer()
        ]))

        weak var wS = self
        selectPeriodViewModel
            .onEvent(\.didTap) {
                wS?.selectPeriodViewModel.set(.hidden(true))
                wS?.userSearchModel.set(.hidden(false))
                print("selectPeriodViewModel")
            }
    }
}

extension TransactViewModel {
    func searchUser(_ request: SearchUserRequest) {
        apiModel
            .onEvent(\.success) { result in
                print(result)
            }
            .sendEvent(\.request, request)
    }
}

struct PickerViewEvent: InitProtocol {
    var didSelectRow: Event<Int>?
}

enum PickerViewState {
    case items([String])
}

final class PickerViewModel: BaseViewModel<UIPickerView> {
    var eventsStore = PickerViewEvent()

    private var items: [String] = []

    override func start() {
        view.dataSource = self
        view.delegate = self
    }
}

extension PickerViewModel: Communicable {}

extension PickerViewModel: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        items[row]
    }

//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 30
//    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendEvent(\.didSelectRow, row)
    }
}

extension PickerViewModel: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }
}

extension PickerViewModel: Stateable2 {
    func applyState(_ state: PickerViewState) {
        switch state {
        case .items(let array):
            items = array
        }
    }

    typealias State = ViewState
    typealias State2 = PickerViewState
}
