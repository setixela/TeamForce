//
//  StringStorageModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import Foundation

protocol StorageEventProtocol: InitProtocol {
   associatedtype AsType

   var saveValueForKey: Event<(value: AsType, key: String)>? { get set }
   var requestValueForKey: Event<String>? { get set }
   var responseValue: Event<AsType>? { get set }
}

struct StorageStringEvent: StorageEventProtocol {
   var saveValueForKey: Event<(value: String, key: String)>?
   var requestValueForKey: Event<String>?
   var responseValue: Event<String>?
}

final class StringStorageModel: BaseModel, Communicable {
   var eventsStore = StorageStringEvent()

   private var storageEngine: StringStorageProtocol?

   convenience init(engine: StringStorageProtocol) {
      self.init()

      storageEngine = engine
   }

   override func start() {
      onEvent(\.requestValueForKey) { [weak self] key in

         guard let token = self?.storageEngine?.load(forKey: key) else {
            print("\nNo value for key: \(key)\n")
            return
         }

         self?.sendEvent(\.responseValue, token)
      }
      onEvent(\.saveValueForKey) { [weak self] keyValue in
         self?.storageEngine?.save(keyValue.value, forKey: keyValue.key)
      }
   }
}

// MARK: - StringStorageProtocol

protocol StringStorageProtocol {
   func save(_ value: String, forKey key: String)
   func load(forKey key: String) -> String?
}

import SwiftKeychainWrapper

struct KeyChainStore: StringStorageProtocol {
   func save(_ value: String, forKey key: String) {
      KeychainWrapper.standard.set(value, forKey: key)
   }

   func load(forKey key: String) -> String? {
      KeychainWrapper.standard.string(forKey: key)
   }
}
