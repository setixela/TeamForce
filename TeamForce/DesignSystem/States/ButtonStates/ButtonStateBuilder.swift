//
//  ButtonStateBuilder.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

protocol ButtonStateProtocol: ButtonElements where DesignElement == [ButtonState] {}

struct ButtonStateBuilder<Design: DesignProtocol>: ButtonStateProtocol {
   var `default`: [ButtonState] { [
      .backColor(Design.color.semantic.activeButtonBack),
      .textColor(Design.color.textInvert),
      .cornerRadius(Design.params.cornerRadius),
      .height(Design.params.buttonHeight),
      .enabled(true),
   ] }

   var transparent: [ButtonState] { [
      .backColor(Design.color.semantic.inactiveButtonBack),
      .cornerRadius(Design.params.cornerRadius),
      .height(Design.params.buttonHeight),
      .textColor(Design.color.text),
      .enabled(true),
   ] }

   var inactive: [ButtonState] { [
      .backColor(Design.color.semantic.inactiveButtonBack),
      .cornerRadius(Design.params.cornerRadius),
      .height(Design.params.buttonHeight),
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

}
