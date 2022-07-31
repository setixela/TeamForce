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

    typealias Work = AsyncWork<In, Out>

   // func doSync(_ input: In) -> Work
    func doAsync(_ input: In) -> Work
    func doAsync(work: Work)
}

extension Asyncable {
    func doAsync(_ input: In) -> Work {
        let work = Work(input: input)
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
