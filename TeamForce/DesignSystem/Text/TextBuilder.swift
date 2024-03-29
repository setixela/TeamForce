//
//  Texts.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import Foundation
import ReactiveWorks

protocol TextsProtocol: InitProtocol {
   associatedtype Button: ButtonTextsProtocol
   associatedtype Title: TitleTextsProtocol

   static var button: Button { get }
   static var title: Title { get }
}

// MARK: - Button texts

protocol ButtonTextsProtocol: InitProtocol {
   var enterButton: String { get }
   var nextButton: String { get }
   var registerButton: String { get }
   var getCodeButton: String { get }
   var changeUserButton: String { get }
   var sendButton: String { get }
   var toTheBeginingButton: String { get }
   var logoutButton: String { get }

   var closeButton: String { get }
}

// MARK: - Title texts

protocol TitleTextsProtocol: InitProtocol {
   // new
   var autorisation: String { get }

   // main
   var digitalThanks: String { get }
   var digitalThanksAbout: String { get }
   var enter: String { get }

   // login
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
   var newTransact: String { get }
   var close: String { get }
   var chooseRecipient: String { get }
   var sendThanks: String { get }
   var availableThanks: String { get }
   var thanksWereSend: String { get }
   var userNotFound: String { get }
   var reasonPlaceholder: String { get }

   // profile
   var myProfile: String { get }

   // errors
   var wrongUsername: String { get }
   var wrongCode: String { get }
   var loadPageError: String { get }
   var connectionError: String { get }

   // verifyScene
   var noCode: String { get }
   var messageEmail: String { get }
   var messageTelegram: String { get }
   
   // historyScene
   var today: String { get }
   var yesterday: String { get }

   // feed deatail
   var comment: String { get }
}

// MARK: - Button texts implements

struct ButtonTexts: ButtonTextsProtocol {
   var enterButton: String { "Войти" }
   var nextButton: String { "Далее" }
   var registerButton: String { "Регистрация" }
   var getCodeButton: String { "Получить код" }
   var changeUserButton: String { "Сменить пользователя" }
   var sendButton: String { "Отправить" }
   var toTheBeginingButton: String { "В начало" }
   var logoutButton: String { "Выйти" }

   var closeButton: String { "Закрыть" }
}

struct TitleTexts: TitleTextsProtocol {
   // new
   var autorisation: String { "Авторизация" }
   // main
   var digitalThanks: String { "Цифровое спасибо" }
   var digitalThanksAbout: String { "Реализация внутренней программы мотивации сотрудников и друзей ТИМ ФОРС" }
   var enter: String { "Войти" }
   var register: String { "Регистрация" }

   // login
   var enterTelegramName: String { "Для входа введите имя пользователя" }
   var enterSmsCode: String { "Введите код" }
   var pressGetCode: String { "Для входа нажмите ”получить код”, или смените пользователя" }
   var userName: String { "Введите имя пользователя" }
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
   var newTransact: String { "Новая благодарность" }
   var close: String { "Закрыть" }
   var chooseRecipient: String { "Выберите получателя" }
   var sendThanks: String { "Перевести спасибок" }
   var availableThanks: String { "Доступно" }
   var reasonPlaceholder: String { "Причина благодарности" }
   var thanksWereSend: String { "Спасибо отправлено" }
   var recipient: String { "Получатель: @" }
   var userNotFound: String { "По вашему запросу\nникого не нашли" }

   // profile
   var myProfile: String { "Мои данные" }

   // errors
   var wrongUsername: String { "Ошибка. Пользователь не найден" }
   var wrongCode: String { "Ошибка. Неверный код" }
   var loadPageError: String { "Не удалось загрузить страницу" }
   var connectionError: String { "Ошибка соединения" }

   // verifyScene
   var noCode: String { "Не приходит код?" }
   var messageEmail: String { "Проверьте корректность введенной почты" }
   var messageTelegram: String { "Перейдите в диалог с ботом (ссылка), напишите ему что-нибудь после чего повторите процедуру аутентификации." }
   
   // historyScene
   var today: String { "Сегодня" }
   var yesterday: String { "Вчера" }

   // feed deatail
   var comment: String { "Комментарий" }
}

struct TextBuilder: TextsProtocol {
   static var button: ButtonTexts { .init() }
   static var title: TitleTexts { .init() }
}

extension KeyPathMaker where Result == String, Key == String {
   func make(_ keypath: KeyPath<Self, String>) -> String {
      NSLocalizedString(self[keyPath: keypath], comment: "")
   }
}
