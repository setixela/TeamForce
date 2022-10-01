//
//  InternetRechability.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.10.2022.
//

import Alamofire

struct InternetRechability {
   private static let sharedInstance = NetworkReachabilityManager()!

   static var isConnectedToInternet: Bool {
      self.sharedInstance.isReachable
   }
}
