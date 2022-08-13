//
//  DesignSystemProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import ReactiveWorks
import UIKit

/*

 ...
 Design.label
 Design.icon
 Design.button
 Design.text
 Design.font
 Design.params

 Design.state.label
 Design.state.button
 Design.state.stack
 Design.state.view
 ...

  */

typealias DSP = DesignProtocol

protocol DesignProtocol: DesignRoot where
   Text: TextsProtocol,
   Color: ColorsElements,
   Icon: IconElements,
   Font: FontProtocol,
   Label: LabelProtocol,
   Button: ButtonProtocol,

   State: StateProtocol,

   Params: ParamsProtocol
{}

extension DesignProtocol {
   static var text: Text { .init() }
   static var color: Color { .init() }
   static var icon: Icon { .init() }
   static var font: Font { .init() }
   static var label: Label { .init() }
   static var button: Button { .init() }

   static var state: State { .init() }

   static var params: Params { .init() }
}
