//
//  UserDefault+helpers.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 28.07.2022.
//

import Foundation

extension UserDefaults {
   enum UserDefaultsKeys: String {
      case isLoggedIn
      case urlBase
   }

   func setIsLoggedIn(value: Bool) {
      set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
      synchronize()
   }

   func isLoggedIn() -> Bool {
      bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
   }
}

extension UserDefaults {
   func saveString(_ value: String, forKey key: UserDefaultsKeys) {
      set(value, forKey: key.rawValue)
      synchronize()
   }

   func loadString(forKey key: UserDefaultsKeys) -> String? {
      string(forKey: key.rawValue)
   }
}
