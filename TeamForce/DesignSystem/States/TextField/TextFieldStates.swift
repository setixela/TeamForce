//
//  TextFieldStateBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import UIKit
import ReactiveWorks

protocol TextFieldElements: InitProtocol, DesignElementable {
   var `default`: DesignElement { get }
   var invisible: [TextFieldState] { get }
}

protocol TextFieldStateProtocol: TextFieldElements where DesignElement == [TextFieldState] {}

struct TextFieldStateBuilder<Design: DSP>: TextFieldStateProtocol, Designable {
   var `default`: [TextFieldState] {[
      .padding(Design.params.contentPadding),
      .placeholder(""),
      .backColor(Design.color.textFieldBack),
      .height(Design.params.buttonHeight),
      .cornerRadius(Design.params.cornerRadius),
      .borderWidth(Design.params.borderWidth),
      .borderColor(Design.color.boundary),
   ]}

   var invisible: [TextFieldState] {[
      .padding(.init(top: 0, left: 0, bottom: 0, right: 0)),
      .placeholder(""),
      .backColor(Design.color.transparent),
      .height(Design.params.buttonHeight)
   ]}
}
