//
//  Config.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import ReactiveWorks
import Foundation
import UIKit

struct Config {
   static let urlBase = "http://176.99.6.251:8888"
   static let isDebug = false
//   static let startDebugScene: KeyPath<ProductionAsset.Scene, SceneModelProtocol> = \.login

   static let isDebugView = true

   static let httpTimeout: TimeInterval = 30

   static let baseAspectWidth: CGFloat = 360
   static var sizeAspectCoeficient: CGFloat { UIScreen.main.bounds.width / baseAspectWidth }
}

extension CGFloat {
   var aspected: CGFloat {
      self * Config.sizeAspectCoeficient
   }

   var aspectInverted: CGFloat {
      CGFloat(self) / Config.sizeAspectCoeficient
   }
}

extension Int {
   var aspected: CGFloat {
      CGFloat(self) * Config.sizeAspectCoeficient
   }

   var aspectInverted: CGFloat {
      CGFloat(self) / Config.sizeAspectCoeficient
   }
}


