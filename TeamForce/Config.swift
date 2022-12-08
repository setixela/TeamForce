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
   private static let urlBaseDebug = "http://176.99.6.251:8888"
   private static let urlBaseProduction = "http://176.99.6.251:8889"

   #if DEBUG
   static var urlBase = UserDefaults.standard.loadString(forKey: .urlBase) ?? urlBaseDebug
   #else
   static var urlBase = UserDefaults.standard.loadString(forKey: .urlBase) ?? urlBaseProduction
   #endif

   static func setDebugMode(_ isDebug: Bool) {
      urlBase = isDebug ? urlBaseDebug : urlBaseProduction
      UserDefaults.standard.saveString(urlBase, forKey: .urlBase)
   }

   static var isDebugServer: Bool {
      urlBase == urlBaseDebug
   }

   static let isPlaygroundScene = false

   static let isDebugView = true

   #if DEBUG
   static let httpTimeout: TimeInterval = 20
   #else
   static let httpTimeout: TimeInterval = 30
   #endif

   static let baseAspectWidth: CGFloat = 360
   static var sizeAspectCoeficient: CGFloat { UIScreen.main.bounds.width / baseAspectWidth }

   static let imageSendSize: CGFloat = 1920
   static let avatarSendSize: CGFloat = 1920

   static let colorSchemeKey = "colorSchemeKey"
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

extension Config {
   enum AppConfig {
      case debug
      case testFlight
      case production
   }

   private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

   // This can be used to add debug statements.
   static var isDebug: Bool {
      #if DEBUG
      return true
      #else
      return false
      #endif
   }

   static var appConfig: AppConfig {
      if isDebug {
         return .debug
      } else if isTestFlight {
         return .testFlight
      } else {
         return .production
      }
   }
}
