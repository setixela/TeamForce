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
