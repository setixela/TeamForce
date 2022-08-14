//
//  Config.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import ReactiveWorks

struct Config {
   static let isDebug = true
   static let startDebugScene: KeyPath<ProductionAsset.Scene, SceneModelProtocol> = \.login

   static let isDebugView = true
}
//
//import UIKit
//
//extension ViewModelProtocol {
//   var uiView: UIView {
//      let vuew = myView()
//      if Config.isDebugView {
//         vuew.backgroundColor = .random
//      }
//      return myView()
//   }
//}
