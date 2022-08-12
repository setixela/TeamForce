//
//  ButtonStateBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

protocol ButtonStateProtocol: ButtonElements where DesignElement == [ButtonState] {
   associatedtype Parameters: ParamsProtocol
}

struct ButtonStateBuilder<Design: DesignProtocol>: ButtonStateProtocol {
   var `default`: [ButtonState] { [
      .backColor(Design.color.activeButton),
      .textColor(Design.color.textInvert),
      .cornerRadius(Parameters.cornerRadius),
      .height(Parameters.buttonHeight),
      .enabled(true),
   ] }

   var transparent: [ButtonState] { [
      .backColor(Design.color.inactiveButton),
      .cornerRadius(Parameters.cornerRadius),
      .height(Parameters.buttonHeight),
      .textColor(Design.color.text),
      .enabled(true),
   ] }

   var inactive: [ButtonState] { [
      .backColor(Design.color.inactiveButton),
      .cornerRadius(Parameters.cornerRadius),
      .height(Parameters.buttonHeight),
      .textColor(Design.color.textInvert),
      .enabled(false),
   ] }

   var tabBar: [ButtonState] { [
      .font(UIFont.systemFont(ofSize: 12, weight: .medium)),
      .backColor(.black.withAlphaComponent(0.38)),
      .cornerRadius(0),
      .height(56),
      .textColor(.white),
      .enabled(true),
      .tint(.white),
      .vertical(true),
   ] }

   typealias Parameters = GlobalParameters
}
