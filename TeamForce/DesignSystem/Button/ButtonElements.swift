//
//  ButtonElements.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks
import UIKit

protocol ButtonElements: InitProtocol, DesignElementable {
   var `default`: DesignElement { get }
   var transparent: DesignElement { get }
   var inactive: DesignElement { get }

   var tabBar: DesignElement { get }
   var brandTransparent: DesignElement { get }
}

protocol ButtonStateProtocol: ButtonElements where DesignElement == [ButtonState] {}

// MARK: - ButtonStateBuilder

struct ButtonStateBuilder<Design: DesignProtocol>: ButtonStateProtocol {
   var `default`: [ButtonState] { [
      .backColor(Design.color.activeButtonBack),
      .textColor(Design.color.textInvert),
      .tint(Design.color.iconInvert),
      .cornerRadius(Design.params.cornerRadius),
      .height(Design.params.buttonHeight),
      .enabled(true),
   ] }

   var transparent: [ButtonState] { [
      .backColor(Design.color.transparent),
      .cornerRadius(Design.params.cornerRadius),
      .height(Design.params.buttonHeight),
      .textColor(Design.color.text),
      .enabled(true),
   ] }

   var inactive: [ButtonState] { [
      .backColor(Design.color.inactiveButtonBack),
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

   var brandTransparent: [ButtonState] { [
      .backColor(Design.color.transparentButtonBack),
      .textColor(Design.color.textBrand),
      .cornerRadius(Design.params.cornerRadius),
      .borderColor(Design.color.iconBrand),
      .borderWidth(Design.params.borderWidth),
      .tint(Design.color.iconBrand),
      .height(Design.params.buttonHeight),
      .imageInset(.init(top: 14, left: 14, bottom: 14, right: 14)),
      .enabled(true),
   ] }
}

protocol ButtonBuilderProtocol: ButtonElements, Designable where DesignElement == ButtonModel {}

// MARK: - Buttons

final class ButtonBuilder<Design: DesignProtocol>: ButtonBuilderProtocol {
   var `default`: ButtonModel {
      .init(Design.state.button.default)
   }

   var transparent: ButtonModel {
      .init(Design.state.button.transparent)
   }

   var inactive: ButtonModel {
      .init(Design.state.button.inactive)
   }

   var tabBar: ButtonModel {
      .init(Design.state.button.tabBar)
   }

   var brandTransparent: ButtonModel {
      .init(Design.state.button.brandTransparent)
   }
}
