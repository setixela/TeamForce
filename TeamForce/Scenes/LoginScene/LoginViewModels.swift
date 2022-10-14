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
   //
   case startActivityIndicator
}

// MARK: - View models

final class LoginViewModels<Design: DSP>: BaseModel, Designable {
   //
   lazy var activityIndicator = ActivityIndicator<Design>()
      .hidden(true)
   //
   lazy var userNameInputModel = TopBadger<IconTextField<Design>>()
      .set(.badgeLabelStates(Design.state.label.defaultError))
      .set(.badgeState(.backColor(Design.color.background)))
      .set(.hideBadge)
      .set {
         $0.mainModel.icon.image(Design.icon.user)
         $0.mainModel.textField
            .disableAutocorrection()
            .placeholder(Design.Text.title.userName)
            .placeholderColor(Design.color.textFieldPlaceholder)
      }

   lazy var smsCodeInputModel = TopBadger<IconTextField<Design>>()
      .set(.badgeLabelStates(Design.state.label.defaultError))
      .set(.badgeState(.backColor(Design.color.background)))
      .set(.hideBadge)
      .set {
         $0.mainModel.icon.image(Design.icon.lock)
         $0.mainModel.textField
            .disableAutocorrection()
            .placeholder(Design.Text.title.enterSmsCode)
            .placeholderColor(Design.color.textFieldPlaceholder)
            .keyboardType(.numberPad)
      }

   lazy var getCodeButton: ButtonModel = Design.button.inactive
      .title(Design.Text.button.getCodeButton)

   lazy var loginButton: ButtonModel = .init(Design.state.button.inactive)
      .title(Design.Text.button.enterButton)
      .hidden(true)
}

extension LoginViewModels: StateMachine {
   func setState(_ state: LoginSceneState) {
      switch state {
      case .inputUserName:
         smsCodeInputModel.hidden(true)
         userNameInputModel.hidden(false)
         loginButton.hidden(true)
         getCodeButton.hidden(false)
         activityIndicator.hidden(true)

      case .inputSmsCode:
         smsCodeInputModel.hidden(false)
         //loginButton.hidden(false)
         getCodeButton.hidden(true)
         activityIndicator.hidden(true)

      case .nameInputParseSuccess(let value):
         userNameInputModel.mainModel.textField.text(value)
         getCodeButton.set(Design.state.button.default)
         userNameInputModel.set(.hideBadge)
         activityIndicator.hidden(true)

      case .nameInputParseError(let value):
         userNameInputModel.mainModel.textField.text(value)
         getCodeButton.set(Design.state.button.inactive)
         userNameInputModel.set(.hideBadge)
         activityIndicator.hidden(true)

      case .smsInputParseSuccess(let value):
         smsCodeInputModel.mainModel.textField.set(.text(value))
         loginButton.set(Design.state.button.default)
         loginButton.send(\.didTap)
         activityIndicator.hidden(true)

      case .smsInputParseError(let value):
         smsCodeInputModel.mainModel.textField.set(.text(value))
         loginButton.set(Design.state.button.inactive)
         activityIndicator.hidden(true)

      case .invalidUserName:
         userNameInputModel.set(.presentBadge(" " + Design.Text.title.wrongUsername + " "))
         activityIndicator.hidden(true)

      case .invalidSmsCode:
         smsCodeInputModel.set(.presentBadge(" " + Design.Text.title.wrongCode + " "))
         activityIndicator.hidden(true)
      case .startActivityIndicator:
         activityIndicator.hidden(false)
      }
   }
}
