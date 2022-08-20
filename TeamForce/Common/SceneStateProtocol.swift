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

   typealias StateFunc = (SceneState) -> Void

   var setStateFunc: StateFunc? {
      weak var slf = self

      return slf?.setState
   }
}

