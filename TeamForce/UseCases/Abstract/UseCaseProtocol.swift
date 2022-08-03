//
//  UseCaseProtocol.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.08.2022.
//

import Foundation

protocol UseCaseProtocol {
   associatedtype In
   associatedtype Out

   func work() -> Work<In, Out>
   func work(_ input: In?) -> Work<In, Out>
}

extension UseCaseProtocol {

   func work(_ input: In? = nil) -> Work<In, Out> {
      fatalError()
   }

//   func work() -> Work<In, Out> {
//      fatalError()
//   }
}
