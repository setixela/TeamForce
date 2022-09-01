//
//  StateProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks

protocol StateProtocol: InitProtocol, Designable {
   associatedtype Stack: StackStatesProtocol
   associatedtype Label: LabelStateProtocol
   associatedtype Button: ButtonStateProtocol
   associatedtype TextField: TextFieldStateProtocol
}

extension StateProtocol {
   var stack: Stack { .init() }
   var label: Label { .init() }
   var button: Button { .init() }
   var textField: TextField { .init() }
}
