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
}

// MARK: - View models

final class LoginViewModels<Asset: AssetProtocol>: Assetable {
   //
   lazy var userNameInputModel: IconTextField<Design> = .init()
      .setMain {
         $0.set_image(Design.icon.user)
      } setRight: {
         $0.set_placeholder(Text.title.userName)
      }

   lazy var smsCodeInputModel: IconTextField<Design> = .init()
      .setMain {
         $0.set_image(Design.icon.lock)
      } setRight: {
         $0.set_placeholder(Text.title.enterSmsCode)
      }
      .set_hidden(true)

   lazy var getCodeButton: ButtonModel = Design.button.inactive
      .set_title(Text.button.getCodeButton)

   lazy var loginButton: ButtonModel = .init(Design.state.button.inactive)
      .set(.title(Text.button.enterButton))
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
         userNameInputModel.textField.set_text(value)
         getCodeButton.set(Asset.Design.state.button.default)

      case .nameInputParseError(let value):
         userNameInputModel.textField.set_text(value)
         getCodeButton.set(Asset.Design.state.button.inactive)

      case .smsInputParseSuccess(let value):
         smsCodeInputModel.textField.set(.text(value))
         loginButton.set(Asset.Design.state.button.default)

      case .smsInputParseError(let value):
         smsCodeInputModel.textField.set(.text(value))
         loginButton.set(Asset.Design.state.button.inactive)
      }
   }
}
