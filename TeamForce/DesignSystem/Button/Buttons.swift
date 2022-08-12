//
//  ButtonsProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.06.2022.
//

import ReactiveWorks
import UIKit

// MARK: - Buttons Protocols

//protocol ButtonsProtocol: InitProtocol, Associated {
//   associatedtype AsType
//
//   var `default`: AsType { get }
//   var transparent: AsType { get }
//   var inactive: AsType { get }
//
//   var tabBar: AsType { get }
//}

protocol ButtonProtocol: ButtonElements, Designable where DesignElement == ButtonModel {}

// MARK: - Buttons

final class DefaultButtonBuilder<Design: DesignProtocol>: ButtonProtocol {
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
}
