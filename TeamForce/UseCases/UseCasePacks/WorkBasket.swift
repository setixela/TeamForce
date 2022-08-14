//
//  WorkBasket.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

// сделать WaitForEvent
import ReactiveWorks

@available(*, deprecated, message: "Use Retainer class now")
protocol WorkBasket {
   var basket: [Any] { get set }
}

extension WorkBasket {
   mutating func workFor<I, O>(_ keypath: KeyPath<Self, Work<I, O>>) -> Work<I, O> {
      let work = self[keyPath: keypath]
      basket.append(work)
      return work
   }

   mutating func retainedWork<U: UseCaseProtocol>(_ keypath: KeyPath<Self, U>) -> Work<U.In, U.Out> {
      let useCase = self[keyPath: keypath]
      let work = useCase.work
      basket.append(work)
      return work
   }
}
