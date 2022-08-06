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
      let viewModel = ViewModel()
         .set(.size(.init(width: 100, height: 100)))
         .set(rightModel: {
            $0.set(.backColor(.yellow))
         })
         .set(leftModel: {
            $0.set(.backColor(.blue))
         })
      let stackModel = StackModel()
      stackModel.set(.models([
         Spacer(size: 300),
         BadgeModel()
            .set(.placing(.init(x: 0, y: -10))),
         viewModel
            .set(.height(50))
            .set(.backColor(.lightGray)),
         BadgeModel(),
         Spacer()
      ]))

      view = stackModel.view
   }
}

nc.viewControllers = [VC()]

final class ViewModel: BaseViewModel<UIView>, Stateable {
   typealias State = ViewState

   let leftModel = ViewModel()
   let rightModel = ViewModel()

   override func start() {
      view.clipsToBounds = false
      view.layer.masksToBounds = false
   }
}

extension ViewModel: RightExtender, LeftExtender {}

final class BadgeModel: BaseViewModel<PaddingLabel> {
   override func start() {
      set(.text("Hello"))
      set(.zPosition(1000))
      set(.backColor(.yellow))
      view.clipsToBounds = true
      view.layer.masksToBounds = true
      view.setNeedsLayout()
      view.setNeedsDisplay()
      view.layoutSubviews()
   }
}

extension BadgeModel: Stateable2 {
   typealias State = LabelState
   typealias State2 = ViewState
}

protocol LeftExtender {
   associatedtype LeftModel: ViewModelProtocol

   var leftModel: LeftModel { get }
}

extension LeftExtender {
   func set(leftModel: (LeftModel) -> Void) -> Self {
      leftModel(self.leftModel)
      return self
   }
}

protocol RightExtender {
   associatedtype RightModel: ViewModelProtocol

   var rightModel: RightModel { get }
}

extension RightExtender {
   func set(rightModel: (RightModel) -> Void) -> Self {
      rightModel(self.rightModel)
      return self
   }
}

extension ViewModelProtocol where Self: LeftExtender {
   init(all: Void) {
      self.init()
   }
}

extension ViewModelProtocol where Self: RightExtender {}

extension ViewModelProtocol where Self: RightExtender, Self: LeftExtender {}
// protocol ExtendableViewModel {
//   enum Side {
//      case left
//      case top
//      case right
//      case bottom
//   }
//   func extendSide(_ side: Side, by model: UIViewModel)
// }
protocol HashableExtra: Hashable {}

extension HashableExtra {

   var caseName: String {
      Mirror(reflecting: self).children.first?.label ?? String(describing: self)
   }

   func hash(into hasher: inout Hasher) {
      hasher.combine(caseName)
   }
}

extension HashableExtra {
   static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.hashValue == rhs.hashValue
   }
}



enum States: HashableExtra {
   case normal
   case selected
}
protocol Changer {
   associatedtype State

   var states: [
      [State]
   ] { get }
}

extension

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
