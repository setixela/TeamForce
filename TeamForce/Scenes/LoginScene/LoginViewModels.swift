//
//  LoginDecors.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

enum LoginSceneState {
   //
   case inputUserName
   case inputSmsCode
   //
   case nameInputParseSuccess(String)
   case nameInputParseError(String)
   //
   case smsInputParseSuccess(String)
   case smsInputParseError(String)
   //
   case invalidUserName
   case invalidSmsCode
}

// MARK: - View models

final class LoginViewModels<Design: DSP>: BaseModel, Designable {
   //
   lazy var userNameInputModel = TopBadger<IconTextField<Design>>()
      .set(.badgeLabelStates(Design.state.label.defaultError))
      .set(.badgeState(.backColor(Design.color.background)))
      .set(.hideBadge)
      .set {
         $0.mainModel.icon.set_image(Design.icon.user)
         $0.mainModel.textField
            .set_placeholder(Design.Text.title.userName)
            .set_placeholderColor(Design.color.textFieldPlaceholder)
      }

   lazy var smsCodeInputModel = TopBadger<IconTextField<Design>>()
      .set(.badgeLabelStates(Design.state.label.defaultError))
      .set(.badgeState(.backColor(Design.color.background)))
      .set(.hideBadge)
      .set {
         $0.mainModel.icon.set_image(Design.icon.lock)
         $0.mainModel.textField
            .set_placeholder(Design.Text.title.enterSmsCode)
            .set_placeholderColor(Design.color.textFieldPlaceholder)
            .set_keyboardType(.numberPad)
      }

   lazy var getCodeButton: ButtonModel = Design.button.inactive
      .set_title(Design.Text.button.getCodeButton)

   lazy var loginButton: ButtonModel = .init(Design.state.button.inactive)
      .set(.title(Design.Text.button.enterButton))
}

extension LoginViewModels: StateMachine {
   func setState(_ state: LoginSceneState) {
      switch state {
      case .inputUserName:
         smsCodeInputModel.set_hidden(true)
         userNameInputModel.set_hidden(false)
         loginButton.set_hidden(true)
         getCodeButton.set_hidden(false)

      case .inputSmsCode:
         smsCodeInputModel.set_hidden(false)
         loginButton.set_hidden(false)
         getCodeButton.set_hidden(true)

      case .nameInputParseSuccess(let value):
         userNameInputModel.mainModel.textField.set_text(value)
         getCodeButton.set(Design.state.button.default)
         userNameInputModel.set(.hideBadge)

      case .nameInputParseError(let value):
         userNameInputModel.mainModel.textField.set_text(value)
         getCodeButton.set(Design.state.button.inactive)
         userNameInputModel.set(.hideBadge)

      case .smsInputParseSuccess(let value):
         smsCodeInputModel.mainModel.textField.set(.text(value))
         loginButton.set(Design.state.button.default)

      case .smsInputParseError(let value):
         smsCodeInputModel.mainModel.textField.set(.text(value))
         loginButton.set(Design.state.button.inactive)

      case .invalidUserName:
         userNameInputModel.set(.presentBadge(" " + Design.Text.title.wrongUsername + " "))

      case .invalidSmsCode:
         smsCodeInputModel.set(.presentBadge(" " + Design.Text.title.wrongCode + " "))
      }
   }
}
