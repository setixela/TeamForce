//
//  EmptyChecker.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.08.2022.
//

import Foundation
import ReactiveWorks

final class IsEmpty<T: Collection>: UseCaseProtocol {
   typealias In = T
   typealias Out = T

   func work() -> Work<In, Out> {
      .init {
         if $0.unsafeInput.isEmpty {
            $0.success(result: $0.unsafeInput)
         } else {
            $0.failThenNext($0.unsafeInput)
         }
      }
   }
}
