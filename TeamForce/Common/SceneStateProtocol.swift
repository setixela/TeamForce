//
//  StateMachine.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import Foundation

protocol StateMachine: AnyObject {
   associatedtype ModelState

   func setState(_ state: ModelState)
}

extension StateMachine {

   var stateDelegate: (ModelState) -> Void {
      let fun: (ModelState) -> Void = { [weak self] in
         self?.setState($0)
      }

      return fun
   }

   func debug(_ state: ModelState) {
      log(state, self)
   }
}

enum ValueState<T> {
   case value(T)
}
