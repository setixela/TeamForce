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

protocol ButtonTextsProtocol: InitProtocol, KeyPathMaker {
    associatedtype TextType

    var enterButton: String { get }
    var nextButton: String { get }
    var registerButton: String { get }
    var getCodeButton: String { get }
    var changeUserButton: String { get }
}

protocol TitleTextsProtocol: InitProtocol, KeyPathMaker {
    associatedtype TextType

    var digitalThanks: String { get }
    var enter: String { get }
    var register: String { get }
    var enterTelegramName: String { get }
    var enterSmsCode: String { get }
    var pressGetCode: String { get }
    var userName: String { get }
    var smsCode: String { get }
    var loginSuccess: String { get }
}

struct ButtonTexts: ButtonTextsProtocol {
    typealias TextType = String

    var enterButton: String { "ВХОД" }
    var nextButton: String { "ДАЛЕЕ" }
    var registerButton: String { "РЕГИСТРАЦИЯ" }
    var getCodeButton: String { "ПОЛУЧИТЬ КОД" }
    var changeUserButton: String { "ПОЛУЧИТЬ КОД" }
}

struct TitleTexts: TitleTextsProtocol {
    typealias TextType = String

    var digitalThanks: String { "Цифровое спасибо" }
    var enter: String { "Вход" }
    var register: String { "Регистрация" }
    var enterTelegramName: String { "Введите имя пользователя telegram или идентификатор" }
    var enterSmsCode: String { "Введите код" }
    var pressGetCode: String { "Для входа нажмите ”получить код”, или смените пользователя" }
    var userName: String { "Имя пользователя" }
    var smsCode: String { "Код подтверждения" }
    var loginSuccess: String { "Вы успешно зарегистрированы" }
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
