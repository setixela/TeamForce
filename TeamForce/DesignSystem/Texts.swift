//
//  Texts.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import Foundation

protocol TextsProtocol: InitProtocol {
    associatedtype Button: ButtonTextsProtocol
    associatedtype Title: TitleTextsProtocol

    var button: Button { get }
    var title: Title { get }
}

// MARK: - Button texts

protocol ButtonTextsProtocol: InitProtocol, KeyPathMaker
    where MakeType == String,
    ValueType == String
{
    var enterButton: String { get }
    var nextButton: String { get }
    var registerButton: String { get }
    var getCodeButton: String { get }
    var changeUserButton: String { get }
}

// MARK: - Title texts

protocol TitleTextsProtocol: InitProtocol, KeyPathMaker
    where MakeType == String,
    ValueType == String
{
    // main
    var digitalThanks: String { get }
    var enter: String { get }
    var register: String { get }
    var enterTelegramName: String { get }
    var enterSmsCode: String { get }
    var pressGetCode: String { get }
    var userName: String { get }
    var smsCode: String { get }
    var loginSuccess: String { get }

    // balance
    var selectPeriod: String { get }
    var myAccount: String { get }
    var leftToSend: String { get }
    var onAgreement: String { get }
    var canceled: String { get }
    var sended: String { get }

    // transact
    var chooseRecipient: String { get }
    var sendThanks: String { get }
    var availableThanks: String { get }
}

// MARK: - Button texts implements

struct ButtonTexts: ButtonTextsProtocol {
    var enterButton: String { "ВХОД" }
    var nextButton: String { "ДАЛЕЕ" }
    var registerButton: String { "РЕГИСТРАЦИЯ" }
    var getCodeButton: String { "ПОЛУЧИТЬ КОД" }
    var changeUserButton: String { "ПОЛУЧИТЬ КОД" }
}

struct TitleTexts: TitleTextsProtocol {
    // main
    var digitalThanks: String { "Цифровое спасибо" }
    var enter: String { "Вход" }
    var register: String { "Регистрация" }
    var enterTelegramName: String { "Введите имя пользователя telegram или идентификатор" }
    var enterSmsCode: String { "Введите код" }
    var pressGetCode: String { "Для входа нажмите ”получить код”, или смените пользователя" }
    var userName: String { "Имя пользователя" }
    var smsCode: String { "Код подтверждения" }
    var loginSuccess: String { "Вы успешно зарегистрированы" }

    // balance
    var selectPeriod: String { "Выберите период" }
    var myAccount: String { "Мой счет" }
    var leftToSend: String { "Осталось раздать" }
    var onAgreement: String { "На согласовании" }
    var canceled: String { "Аннулировано" }
    var sended: String { "Распределено" }

    // transact
    var chooseRecipient: String { "Выберите получателя" }
    var sendThanks: String { "Перевести спасибок" }
    var availableThanks: String { "Доступно" }
}

struct Texts: TextsProtocol, KeyPathMaker {
    let button = ButtonTexts()
    let title = TitleTexts()
}

extension KeyPathMaker where MakeType == String, ValueType == String {
    func make(_ keypath: KeyPath<Self, String>) -> String {
        // Make transformations
        NSLocalizedString(self[keyPath: keypath], comment: "")
    }
}
