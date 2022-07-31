//
//  AsyncWorker.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 30.07.2022.
//

import Foundation

protocol Asyncable: AnyObject {
   associatedtype In
   associatedtype Out

   typealias W = Work<In, Out>

   // func doSync(_ input: In) -> Work
   func doAsync(_ input: In) -> W
   func doAsync(work: W)
}

extension Asyncable {
   func doAsync(_ input: In) -> W {
      let work = W(input: input)
      work.closure = doAsync(work:)
      DispatchQueue.main.async {
         work.closure?(work)
      }
      return work
   }

//    func doSync(_ input: In) -> Work {
//        let work = Work(input: input)
//        work.closure = doAsync(work:)
//        work.closure?(work)
//        return work
//    }
}
