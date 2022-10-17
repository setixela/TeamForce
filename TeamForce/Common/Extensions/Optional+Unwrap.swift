//
//  Optional+Unwrap.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.09.2022.
//

import Foundation

extension Optional where Wrapped == String {
   var string: String { self ?? "" }
}

extension Optional where Wrapped == Bool {
   var bool: Bool { self ?? false }
}

extension Optional where Wrapped == Int {
   var int: Int { self ?? 0 }
}
