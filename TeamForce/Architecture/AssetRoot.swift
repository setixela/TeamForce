//
//  AssetRoot.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 04.08.2022.
//

import Foundation

protocol AssetRoot {
   associatedtype Scene: InitProtocol
   associatedtype Service: InitProtocol
   associatedtype Design: InitProtocol
   associatedtype Text: InitProtocol

   typealias Asset = Self
}

extension AssetRoot {
   static var service: Service { .init() }
   static var design: Design { .init() }
   static var text: Text { .init() }
}
