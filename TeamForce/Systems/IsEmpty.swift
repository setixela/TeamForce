//
//  EmptyChecker.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.08.2022.
//

import Foundation
import ReactiveWorks

final class IsEmptyToBool<T: Collection>: WorkerProtocol {
   typealias In = T
   typealias Out = Bool

   func doAsync(work: Wrk) {
      if work.unsafeInput.isEmpty {
         work.success(result: true)
      } else {
         work.success(result: false)
      }
   }
}

final class IsNotEmptyToBool<T: Collection>: WorkerProtocol {
   typealias In = T
   typealias Out = Bool

   func doAsync(work: Wrk) {
      if !work.unsafeInput.isEmpty {
         work.success(result: true)
      } else {
         work.success(result: false)
      }
   }
}

final class ArrayFilter<T>: WorkerProtocol {
   typealias In = T
   typealias Out = [Any]

   func doAsync(work: Wrk) {
      if work.unsafeInput is Out {
         work.success(result: work.unsafeInput as! Out)
      } else {
         work.fail()
      }
   }
}

final class IsEmpty<T: Collection>: UseCaseProtocol {
   typealias In = T
   typealias Out = T

   var work: Work<In, Out> {
      .init {
         if $0.unsafeInput.isEmpty {
            $0.success(result: $0.unsafeInput)
         } else {
            $0.fail($0.unsafeInput)
         }
      }
   }
}

final class IsNotEmpty<T: Collection>: UseCaseProtocol {
   typealias In = T
   typealias Out = T

   var work: Work<In, Out> {
      .init {
         if !$0.unsafeInput.isEmpty {
            $0.success(result: $0.unsafeInput)
         } else {
            $0.fail($0.unsafeInput)
         }
      }
   }
}
