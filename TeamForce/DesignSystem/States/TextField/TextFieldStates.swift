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
      .padding(.init(top: 16, left: 16, bottom: 16, right: 16)),
      .placeholder(""),
      .backColor(Design.color.textFieldBack),
      .height(Design.params.buttonHeight)
   ]}

   var invisible: [TextFieldState] {[
      .padding(.init(top: 0, left: 0, bottom: 0, right: 0)),
      .placeholder(""),
      .backColor(Design.color.transparent),
      .height(Design.params.buttonHeight)
   ]}
}
