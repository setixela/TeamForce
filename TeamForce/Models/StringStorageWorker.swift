//
//  StringStorageModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.07.2022.
//

import Foundation
import ReactiveWorks

enum StorageError: Error {
   case noValue
}

protocol StorageEventProtocol: InitProtocol {
   associatedtype AsType

   var saveValueForKey: Event<(value: AsType, key: String)>? { get set }
   var requestValueForKey: Event<String>? { get set }
   var responseValue: Event<AsType>? { get set }
   var error: Event<StorageError>? { get set }
}

struct StorageStringEvent: StorageEventProtocol {
   var saveValueForKey: Event<(value: String, key: String)>?
   var requestValueForKey: Event<String>?
   var responseValue: Event<String>?
   var error: Event<StorageError>?
}

final class StringStorageWorker: BaseModel {
   private var storageEngine: StringStorageProtocol?

   convenience init(engine: StringStorageProtocol) {
      self.init()

      storageEngine = engine
   }
}

extension StringStorageWorker: WorkerProtocol {
   func doAsync(work: Work<String, String>) {
      guard
         let input = work.input,
         let value = storageEngine?.load(forKey: input)
      else {
         print("\nNo value for key: \(String(describing: work.input))\n")

         work.fail(())
         return
      }

      work.success(result: value)
   }
}

extension StringStorageWorker: Stateable {
   enum State {
      case saveValueForKey((value: String, key: String))
   }

   func applyState(_ state: State) {
      switch state {
      case .saveValueForKey(let keyValue):
         storageEngine?.save(keyValue.value, forKey: keyValue.key)
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
