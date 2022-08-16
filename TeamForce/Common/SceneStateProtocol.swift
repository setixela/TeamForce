//
//  SceneStateProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import Foundation

protocol SceneStateProtocol {
   associatedtype SceneState
   
   func setState(_ state: SceneState)
}
