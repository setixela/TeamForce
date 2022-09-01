//
//  String+Random.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation

extension String {
   static func randomInt(_ max: Int) -> String {
      String(Int.random(in: 0 ... max))
   }

   static var randomUrlImage: String {
      "https://picsum.photos/200"
   }
}
