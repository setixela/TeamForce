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
        print("\nStart TextFieldModel\n")
        view.addAnchors.constHeight(48)
        view.padding = .init(top: 16, left: 16, bottom: 16, right: 16)
        view.backgroundColor = .lightGray
        view.delegate = self
        view.addTarget(self, action: #selector(changValue), for: .editingChanged)

        weak var weakSelf = self

        onEvent(\.setText) { text in
            print("setText ", text)
            weakSelf?.view.text = text
        }
        .onEvent(\.setPlaceholder) { text in
            print("setPlaceholder ", text)
            weakSelf?.view.placeholder = text
        }
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
    var response: Event<String>?
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
                self?.sendEvent(\.response, resultText)
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

    override func start() {
        onEvent(\.request) { [weak self] text in

            if text.count == 4 {
                self?.sendEvent(\.response, text)
            } else {
                self?.sendEvent(\.error, text)
            }
        }
    }
}

extension SmsCodeCheckerModel: Communicable {}
