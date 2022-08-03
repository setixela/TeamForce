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

let work1 = Work<Int, Int>(input: 0)

let event = 
let asyncWork = Work<String, Int>(input: "input") { work in
   print("start")
   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      work.success(result: (work.input ?? "").count)
   }
}.onSuccess { value in
   print("result")
   print(value + 10)
   print(type(of: value))
}.doAsync { work in
   print("start")
   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      work.success(result: "\(String(describing: work.input))")
   }
}.onSuccess { (value: String) in
   print("result")
   print(value + "10")
   print(type(of: value))
}

//asyncWork.doAsync("1")
//asyncWork.doAsync("22")
//asyncWork.doAsync("333")
print("Async initated")

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
