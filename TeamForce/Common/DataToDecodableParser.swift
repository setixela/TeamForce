//
//  DataToDecodableParser.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.08.2022.
//

import Foundation

struct DataToDecodableParser {
   func parse<T: Decodable>(_ data: Data) -> T? {
      let decoder = JSONDecoder()

      guard
         let result = try? decoder.decode(T.self, from: data)
      else {
         return nil
      }

      return result
   }

//   func parseArray<T: Decodable>(_ data: Data) -> [T]? {
//      let decoder = JSONDecoder()
//
//      guard
//         let result = try? decoder.decode([T].self, from: data)
//      else {
//         return nil
//      }
//
//      return result
//   }
}

//do {
//    let result = try decoder.decode(T.self, from: data)
//    return result
//} catch DecodingError.keyNotFound(let key, let context) {
//     Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
// } catch DecodingError.valueNotFound(let type, let context) {
//     Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
// } catch DecodingError.typeMismatch(let type, let context) {
//     Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
// } catch DecodingError.dataCorrupted(let context) {
//     Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
// } catch let error as NSError {
//     NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
// }

