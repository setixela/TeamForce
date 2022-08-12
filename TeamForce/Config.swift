//
//  Config.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import ReactiveWorks

struct Config {
   static let isDebug = false
   static let startDebugScene: KeyPath<ProductionAsset.Scene, SceneModelProtocol> = \.login

   static let isDebugView = true
}
