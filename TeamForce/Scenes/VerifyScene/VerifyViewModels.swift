//
//  VerifyViewModels.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import ReactiveWorks

enum VerifySceneState {
   //
   case inputSmsCode
   //
   case smsInputParseSuccess(String)
   case smsInputParseError(String)
   //
   case invalidSmsCode
   //
   case startActivityIndicator
}

// MARK: - View models

final class VerifyViewModels<Design: DSP>: BaseModel, Designable {
   //
   lazy var activityIndicator = ActivityIndicator<Design>()
      .hidden(true)
   //

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

   lazy var loginButton: ButtonModel = .init(Design.state.button.inactive)
      .title(Design.Text.button.enterButton)
      .hidden(true)
}

extension VerifyViewModels: StateMachine {
   func setState(_ state: VerifySceneState) {
      switch state {
      case .inputSmsCode:
         smsCodeInputModel.hidden(false)
         // loginButton.hidden(false)
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

      case .invalidSmsCode:
         smsCodeInputModel.set(.presentBadge(" " + Design.Text.title.wrongCode + " "))
         activityIndicator.hidden(true)
      case .startActivityIndicator:
         activityIndicator.hidden(false)
      }
   }
}
