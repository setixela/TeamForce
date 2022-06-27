//
//  TextFieldModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - TextFieldModel

final class TextFieldModel: BaseViewModel<PaddingTextField> {
    var eventsStore: Events = .init()

    override func start() {
        weak var weakSelf = self

        setupView()
        onEvent(\.setText) { text in
            print("setText ", text)
            weakSelf?.view.text = text
        }
        .onEvent(\.setPlaceholder) { text in
            print("setPlaceholder ", text)
            weakSelf?.view.placeholder = text
        }
    }

    private func setupView() {
        view.addAnchors.constHeight(48)
        view.padding = .init(top: 16, left: 16, bottom: 16, right: 16)
        view.backgroundColor = .lightGray
        view.delegate = self
        view.addTarget(self, action: #selector(changValue), for: .editingChanged)
    }

    @objc func changValue() {
        guard let text = view.text else { return }

        sendEvent(\.didEditingChanged, text)
    }
}

extension TextFieldModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // view.becomeFirstResponder()
    }
}

extension TextFieldModel: Communicable {
    struct Events: InitProtocol {
        var didEditingChanged: Event<String>?
        var setText: Event<String>?
        var setPlaceholder: Event<String>?
    }
}

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
