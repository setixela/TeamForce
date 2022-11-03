//
//  Config.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 11.08.2022.
//

import Foundation
import ReactiveWorks
import UIKit

struct Config {
   #if DEBUG
   static let urlBase = "http://176.99.6.251:8888"
   #else
   static let urlBase = "http://176.99.6.251:8889"
   #endif

   static let isDebug = false

   static let isDebugView = true

   #if DEBUG
   static let httpTimeout: TimeInterval = 5
   #else
   static let httpTimeout: TimeInterval = 30
   #endif
   
   static let baseAspectWidth: CGFloat = 360
   static var sizeAspectCoeficient: CGFloat { UIScreen.main.bounds.width / baseAspectWidth }

   static let imageSendSize: CGFloat = 1920
   static let avatarSendSize: CGFloat = 1920
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
