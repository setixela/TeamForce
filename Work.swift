//
//  AsyncWork.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 30.07.2022.
//

import Foundation
import SwiftUI

// MARK: - Aliases

typealias WorkClosure<In, Out> = (Work<In, Out>) -> Void
typealias MapClosure<In, Out> = (In) -> Out

// MARK: - AsyncWorkGeneric

protocol WorkProtocol: AnyObject {
   associatedtype In
   associatedtype Out

   var input: In? { get set }
   var result: Out? { get set }

   var closure: WorkClosure<In, Out>? { get set }

   func success(result: Out)

   func doAsync<Out2>(work: Work<Out, Out2>) -> Work<Out, Out2>
   func doAsync<Out2>(_ closure: @escaping WorkClosure<Out, Out2>) -> Work<Out, Out2>
   func doAsync<Worker>(worker: Worker, input: Worker.In?) -> Work<Worker.In, Worker.Out> where Worker: Asyncable, Out == Worker.In

   @discardableResult func onSuccess(_ finisher: @escaping (Out) -> Void) -> Self
   @discardableResult func onFail<T>(_ failure: @escaping GenericClosure<T>) -> Self
}

// MARK: - AsyncWork

//////////////// 'IN' MUST BE 'DEFAULTABLE'!!!!!!!!!!!!!!!
///
final class Work<In, Out>: WorkProtocol {
   var input: In?
   var result: Out?

   var closure: WorkClosure<In, Out>?

   private var finisher: ((Out) -> Void)?

   private var genericFail: LambdaProtocol?

   private var nextWork: WorkWrappperProtocol?
   private var mapperWork: WorkWrappperProtocol?
   private var inputWork: WorkWrappperProtocol?

   init(input: In?, _ closure: @escaping WorkClosure<In, Out>) {
      self.input = input
      self.closure = closure
   }

   init(input: In? = nil) {
      self.input = input
   }

   func success(result: Out) {
      self.result = result

      finisher?(result)
      inputWork?.perform(())
      if let mapperWork = mapperWork {
         mapperWork.perform(result)
      } else {
         nextWork?.perform(result)
      }
      
      clean()
   }

   func fail<T>(_ value: T) {
      genericFail?.perform(value)
      genericFail?.perform(())
      clean()
   }
}

// exte
extension Work {
   @discardableResult
   func doAsync<Out2>(work: Work<Out, Out2>) -> Work<Out, Out2> {
      nextWork = WorkWrappper<Out, Out2>(work: work)

      return work
   }

   @discardableResult
   func doAsync<Out2>(_ closure: @escaping WorkClosure<Out, Out2>) -> Work<Out, Out2> {
      let newWork = Work<Out, Out2>(input: nil, closure)
      nextWork = WorkWrappper<Out, Out2>(work: newWork)

      return newWork
   }

   @discardableResult
   func doAsync<Worker>(worker: Worker, input: Worker.In? = nil)
      -> Work<Worker.In, Worker.Out>
      where Worker: Asyncable, Out == Worker.In
   {
      let work = Work<Worker.In, Worker.Out>(input: input, worker.doAsync(work:))
      nextWork = WorkWrappper<Worker.In, Worker.Out>(work: work)

      return work
   }

   @discardableResult func onSuccess(_ finisher: @escaping (Out) -> Void) -> Self {
      self.finisher = finisher

      return self
   }

   @discardableResult func onFail<T>(_ failure: @escaping GenericClosure<T>) -> Self {
      genericFail = Lambda(lambda: failure)

      return self
   }

   @discardableResult func doMap<T>(_ mapper: @escaping MapClosure<Out, T>) -> Work<Out, T> {
      let work = Work<Out, T>()
      work.closure = { work in
         guard let input = work.input else {
            work.fail(())
            return
         }

         work.success(result: mapper(input))
      }
      mapperWork = WorkWrappper(work: work)

      return work
   }

   @discardableResult func doInput<T>(_ input: T?) -> Work<Out, T> {
      let work = Work<Out, T>()
      work.closure = {
         guard let input = input else {
            $0.fail(())
            return
         }

         $0.success(result: input)
      }
      inputWork = WorkWrappper(work: work)

      return work
   }

   @discardableResult func doInput<T>(_ input: @escaping () -> T?) -> Work<Out, T> {
      let work = Work<Out, T>()
      work.closure = {
         guard let input = input() else {
            $0.fail(())
            return
         }
         $0.success(result: input)
      }
      inputWork = WorkWrappper(work: work)

      return work
   }
}

extension Work {
   private func clean() {
      finisher = nil
      nextWork = nil
      genericFail = nil
      mapperWork = nil
      inputWork = nil
   }
}

// MARK: - Erasing Work Wrapper

protocol WorkWrappperProtocol {
   func perform<AnyType>(_ value: AnyType)
}

struct WorkWrappper<T, U>: WorkWrappperProtocol where T: Any, U: Any {
   func perform<AnyType>(_ value: AnyType) where AnyType: Any {
      guard
         let value = value as? T
      else {
         print("Lambda payloads not conform: {\(value)} is not {\(T.self)}")
         return
      }

      if work.input == nil {
         work.input = value
      }

      guard let closure = work.closure else {
         // work.result = value
         return
      }

      closure(work)
   }

   let work: Work<T, U>
}
