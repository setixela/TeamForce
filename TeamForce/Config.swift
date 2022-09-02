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
   static let isDebug = false
//   static let startDebugScene: KeyPath<ProductionAsset.Scene, SceneModelProtocol> = \.login

   static let isDebugView = true

   static let httpTimeout: TimeInterval = 3

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


