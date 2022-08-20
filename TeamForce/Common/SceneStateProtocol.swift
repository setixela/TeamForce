//
//  SceneStateProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import Foundation

protocol SceneStateProtocol: AnyObject {
   associatedtype SceneState

   func setState(_ state: SceneState)
}

extension SceneStateProtocol {

   var stateDelegate: (SceneState) -> Void {

      let fun: (SceneState) -> Void = { [weak self] in
         self?.setState($0)
      }

      return fun
   }
}

