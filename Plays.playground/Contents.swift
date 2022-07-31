//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import PromiseKit
import RealmSwift
import SwiftUI
@testable import TeamForce
import UIKit

func example(_ name: String = "", action: () -> Void) {
    print("\n--- Example \(name):")
    action()
}

let nc = UINavigationController()
nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
PlaygroundPage.current.liveView = nc

///////// """ STATEABLE -> PARAMETRIC """

protocol AsyncWorkerProto {
    var workWrapper: WorkWrappperProtocol { get }
    // func doAsync(_ input: In) -> AsyncWork<In, Out>
}

extension AsyncWorkerProto {
    func perform(work: Any) {
        workWrapper.perform(work)
    }
}

class AsyncWorker<In, Out> {
    private var work: AsyncWork<In, Out>?

    func doAsync(_ input: In, closure: @escaping AsyncClosure<In, Out>) -> AsyncWork<In, Out> {
        let work = AsyncWork<In, Out>(input: input)
        self.work = work
        DispatchQueue.main.async {
            closure(work)
        }
        return work
    }
}

// final class AsyncModel: AsyncWorkerProtocol {
//
// }

let modelA = AsyncWorker<String, Int>()
let modelB = AsyncWorker<Int, String>()

let asyncWork = AsyncWork<String, Int>(input: "input") { work in
    print("start")
    Thread.sleep(until: .now + 3)
    work.success(result: (work.input ?? "").count)
}.result { value in
    print("result")
    print(value + 10)
    print(type(of: value))
}.nextAsync { work in
    print("start")
    Thread.sleep(until: .now + 3)
    work.success(result: "\(String(describing: work.input))")
}.result { (value: String) in
    print("result")
    print(value + "10")
    print(type(of: value))
}

print("Async initated")

modelA
    .doAsync("input") { work in
        print("#############")
        print("start")
        Thread.sleep(until: .now + 3)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //  work.perform(result: work.input.count)
        work.success(result: (work.input ?? "").count)
//        }
    }
    .result { (_: Int) in
        print("result")
    }
    .nextAsync { work in
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            work.success(result: "\(work.input)")
        }
    }
    .result { (_: String) in
        print("result 2")
    }

//    .result {
//        print($0)
//        print(type(of: $0))
//    }
//    .nextWork(for: modelA)
//    .result {
//        print($0)
//        print(type(of: $0))
//    }

//    .map {
//        $0.count
//    }
//    .result {
//        print($0)
//    }

//    .map {
//        $0.count
//    }
//

//    .nextWork(modelB)
//    .map {
//        $0
//    }
//    .finish {
//        print($0)
//    }
//    .map {
//        $0 + "10"
//    }
////
//    .nextWork(modelA)
//    .map {
//        print($0)
//        return String($0)
//    }
//    .map {
//        $0 + "10"
//    }
//    .finish {
//        print($0)
//    }

//    .finish {
//
//    }

// MARK: - Todo

// public protocol TargetViewProtocol: UIView {
//    associatedtype TargetView: UIView
//
//    var targetView: TargetView { get }
// }
//
// final class TargetViewModel<TVM: ViewModelProtocol>: BaseViewModel<TVM.View> {
//    lazy var targetModel = TVM()
//
//    override func start() {}
// }
//
// final class TargetView<View: UIView>: UIView, TargetViewProtocol {
//    lazy var targetView: View = {
//        let view = View()
//        self.addSubview(view)
//        return view
//    }()
//
//    typealias TargetView = View
// }
