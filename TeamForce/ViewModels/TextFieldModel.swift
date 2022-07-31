//
//  TextFieldModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - TextFieldModel

enum TextFieldState {
    case text(String)
    case placeholder(String)
    case font(UIFont)
    case clearButtonMode(UITextField.ViewMode)
    case padding(UIEdgeInsets)
    case height(CGFloat)
    case widht(CGFloat)
}

struct TextFieldEvents: InitProtocol {
    var didEditingChanged: Event<String>?
    var didTap: Event<Void>?
}

final class TextFieldModel: BaseViewModel<PaddingTextField> {
    var eventsStore: TextFieldEvents = .init()

    override func start() {
        set(.backColor(.lightGray.withAlphaComponent(0.3)))
        set(.clearButtonMode(.whileEditing))
        set(.cornerRadius(GlobalParameters.cornerRadius))
        view.delegate = self
        view.addTarget(self, action: #selector(changValue), for: .editingChanged)
        view.addTarget(self, action: #selector(didTap), for: .touchDown)
    }

    @objc func changValue() {
        guard let text = view.text else { return }

        sendEvent(\.didEditingChanged, text)
    }

    @objc func didTap() {
        sendEvent(\.didTap)
        print("Did tap textfield")
    }
}

extension TextFieldModel: Stateable2 {
    typealias State = ViewState

    func applyState(_ state: TextFieldState) {
        switch state {
        case .text(let string):
            view.text = string
        case .placeholder(let string):
            view.placeholder = string
        case .font(let font):
            view.font = font
        case .clearButtonMode(let value):
            view.clearButtonMode = value
        case .padding(let value):
            view.padding = value
        case .height(let value):
            view.addAnchors.constHeight(value)
        case .widht(let value):
            view.addAnchors.constWidth(value)
        }
    }
}

extension TextFieldModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // view.becomeFirstResponder()
    }
}

extension TextFieldModel: Communicable {}

// MARK: - TelegramNickCheckerModel

final class TelegramNickCheckerModel: BaseModel {}

extension TelegramNickCheckerModel: Asyncable {
    func doAsync(work: AsyncWork<String, String>) {
        guard let text = work.input else { return }

        var resultText = text == "" ? "@" : text
        if !resultText.hasPrefix("@") {
            resultText = "@" + resultText
        }
        if resultText.count > 3 {
            work.success(result: resultText)
        } else {
            work.fail(resultText)
        }
    }
}

// MARK: - SmsCodeCheckerModel

final class SmsCodeCheckerModel: BaseModel {
    private var maxDigits: Int = 4

    convenience init(maxDigits: Int) {
        self.init()
        self.maxDigits = maxDigits
    }
}

extension SmsCodeCheckerModel: Asyncable {
    //
    func doAsync(work: AsyncWork<String, String>) {
        guard let text = work.input else { return }

        if text.count >= maxDigits {
            let text = text.dropLast(text.count - maxDigits)
            work.success(result: String(text))
        } else {
            work.fail(text)
        }
    }
}
