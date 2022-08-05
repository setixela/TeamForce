//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
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

class VC: UIViewController {
   override func loadView() {
      let stackModel = StackModel()
      stackModel.set(.models([

      ]))

      view = stackModel.view

   }
}

nc.viewControllers = [VC()]

final class BadgeModel: BaseViewModel<PaddingLabel> {
   override func start() {
      set(.text("Hello"))
   }
}

//extension BadgeModel: Stateable {
//   typealias State = LabelState
//}
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
