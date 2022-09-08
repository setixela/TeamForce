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
