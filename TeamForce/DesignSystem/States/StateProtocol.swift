//
//  StateProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 13.08.2022.
//

import ReactiveWorks

protocol StateProtocol: InitProtocol, Designable {
   associatedtype Label: LabelStateProtocol
   associatedtype Button: ButtonStateProtocol
   associatedtype Stack: StackStatesProtocol
   associatedtype TextField: TextFieldStateProtocol
}

extension StateProtocol {
   var label: Label { .init() }
   var button: Button { .init() }
   var stack: Stack { .init() }
   var textField: TextField { .init() }
}
