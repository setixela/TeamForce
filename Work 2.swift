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

//
// protocol WorkProtocol: AnyObject {
//   associatedtype In
//   associatedtype Out
//
//   var input: In? { get set }
//   var result: Out? { get set }
//
//   var closure: WorkClosure<In, Out>? { get set }
//
//   func success(result: Out)
//
//   func doAsync<Out2>(work: Work<Out, Out2>) -> Work<Out, Out2>
//   func doAsync<U: UseCaseProtocol>(usecase: U, input: U.In?) -> Work<U.In, U.Out>
//   func doAsync<Out2>(_ closure: @escaping WorkClosure<Out, Out2>) -> Work<Out, Out2>
//   func doAsync<Worker>(worker: Worker, input: Worker.In?) -> Work<Worker.In, Worker.Out> where Worker: Asyncable, Out == Worker.In
//
//   @discardableResult func onSuccess(_ finisher: @escaping (Out) -> Void) -> Self
//   @discardableResult func onFail<T>(_ failure: @escaping GenericClosure<T>) -> Self
// }

// MARK: - AsyncWork

//////////////// 'IN' MUST BE 'DEFAULTABLE'!!!!!!!!!!!!!!!

final class Work<In, Out> {
   var input: In?

   var unsafeInput: In {
      guard let input = input else {
         fatalError()
      }

      return input
   }

   var result: Out?

   var closure: WorkClosure<In, Out>?

   private var finisher: ((Out) -> Void)?

   private var genericFail: LambdaProtocol?

   private var nextWork: WorkWrappperProtocol?

   init(input: In?, _ closure: @escaping WorkClosure<In, Out>) {
      self.input = input
      self.closure = closure
   }

   init(_ closure: @escaping WorkClosure<In, Out>) {
      self.closure = closure
   }

   init(input: In? = nil) {
      self.input = input
   }

   func success(result: Out) {
      self.result = result

      finisher?(result)
      nextWork?.perform(result)
   }

   func failThenNext<T>(_ value: T) {
      genericFail?.perform(value)
      nextWork?.perform(value)
   }

   func fail<T>(_ value: T) {
      genericFail?.perform(value)
   }
}

extension Work {
   @discardableResult func onSuccess(_ finisher: @escaping (Out) -> Void) -> Self {
      self.finisher = finisher

      return self
   }

   @discardableResult func onFail<T>(_ failure: @escaping GenericClosure<T>) -> Self {
      genericFail = Lambda(lambda: failure)

      return self
   }
}

// exte
extension Work {
   @discardableResult
   func doNext<Out2>(work: Work<Out, Out2>) -> Work<Out, Out2> {
      nextWork = WorkWrappper<Out, Out2>(work: work)

      return work
   }

   @discardableResult
   func doNext<U: UseCaseProtocol>(usecase: U) -> Work<U.In, U.Out>
      where Out == U.In
   {
      let work = usecase.work()
      nextWork = WorkWrappper<U.In, U.Out>(work: work)
      return work
   }

   @discardableResult
   func doNext<Out2>(_ closure: @escaping WorkClosure<Out, Out2>) -> Work<Out, Out2> {
      let newWork = Work<Out, Out2>(input: nil, closure)
      nextWork = WorkWrappper<Out, Out2>(work: newWork)

      return newWork
   }

   @discardableResult
   func doNext<Worker>(worker: Worker, input: Worker.In? = nil)
      -> Work<Worker.In, Worker.Out>
      where Worker: WorkerProtocol, Out == Worker.In
   {
      let work = Work<Worker.In, Worker.Out>(input: input, worker.doAsync(work:))
      nextWork = WorkWrappper<Worker.In, Worker.Out>(work: work)

      return work
   }

   @discardableResult func doMap<T>(_ mapper: @escaping MapClosure<Out, T?>) -> Work<Out, T> {
      let work = Work<Out, T>()
      work.closure = { work in
         guard let input = work.input else {
            work.fail(())
            return
         }

         guard let result = mapper(input) else {
            work.fail(())
            return
         }

         work.success(result: result)
      }
      nextWork = WorkWrappper(work: work)

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
      nextWork = WorkWrappper(work: work)

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
      nextWork = WorkWrappper(work: work)

      return work
   }
}

extension Work {
   @discardableResult
   func doSync() -> Self {
      closure?(self)

      return self
   }

   @discardableResult
   func doSync(_ input: In?) -> Self {
      self.input = input
      closure?(self)

      return self
   }

   @discardableResult
   func doAsync() -> Self {
      DispatchQueue.main.async { [weak self] in
         guard let self = self else { return }

         self.closure?(self)
      }
      return self
   }

   @discardableResult
   func doAsync(_ input: In?) -> Self {
      self.input = input
      DispatchQueue.main.async { [weak self] in
         guard let self = self else { return }

         self.closure?(self)
      }
      return self
   }
}

extension Work {
   private func clean() {
      finisher = nil
      nextWork = nil
      genericFail = nil
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

      work.input = value

      guard let closure = work.closure else {
         return
      }

      closure(work)
   }

   let work: Work<T, U>
}
