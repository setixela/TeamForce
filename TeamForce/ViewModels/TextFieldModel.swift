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
}

final class TextFieldModel: BaseViewModel<PaddingTextField> {
    var eventsStore: TextFieldEvents = .init()

    override func start() {
        set(.backColor(.lightGray.withAlphaComponent(0.3)))
        set(.clearButtonMode(.whileEditing))
        set(.cornerRadius(GlobalParameters.cornerRadius))
    //    view.padding = .init(top: 0, left: 16, bottom: 0, right: 16)
        view.delegate = self
        view.addTarget(self, action: #selector(changValue), for: .editingChanged)
    }

    @objc func changValue() {
        guard let text = view.text else { return }

        sendEvent(\.didEditingChanged, text)
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

// MARK: - InputParserEvents

struct InputParserEvents: InitProtocol {
    var request: Event<String>?
    var success: Event<String>?
    var error: Event<String>?
}

// MARK: - TelegramNickCheckerModel

final class TelegramNickCheckerModel: BaseModel {
    var eventsStore: InputParserEvents = .init()

    override func start() {
        onEvent(\.request) { [weak self] text in
            var resultText = text == "" ? "@" : text
            if !resultText.hasPrefix("@") {
                resultText = "@" + resultText
            }
            if resultText.count > 3 {
                self?.sendEvent(\.success, resultText)
            } else {
                self?.sendEvent(\.error, resultText)
            }
        }
    }
}

extension TelegramNickCheckerModel: Communicable {}

// MARK: - SmsCodeCheckerModel

final class SmsCodeCheckerModel: BaseModel {
    var eventsStore: InputParserEvents = .init()

    private var maxDigits: Int = 4

    convenience init(maxDigits: Int) {
        self.init()
        self.maxDigits = maxDigits
    }

    override func start() {
        onEvent(\.request) { [weak self] text in
            guard let self = self else { return }

            if text.count >= self.maxDigits {
                let text = text.dropLast(text.count - self.maxDigits)
                self.sendEvent(\.success, String(text))
            } else {
                self.sendEvent(\.error, text)
            }
        }
    }
}

extension SmsCodeCheckerModel: Communicable {}
