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

///// MARK: - СДЕЛАТЬ АНИМАЦИЮ ПОЯВЛЕНИЯ БЛОКОВ

let work1 = Work<Int, Int>(input: 0)

//   .setLeft {
//      $0
//         .set(.backColor(.blue))
//         .set(.size(.init(width: 100, height: 100)))
//   }

class VC: UIViewController {
   override func loadView() {
      let viewModel = DoubleViewModel()
         .set(.size(.init(width: 100, height: 100)))
         .setRight {
            $0
               .set(.backColor(.yellow))
               .set(.size(.init(width: 100, height: 100)))
         }
      let stackModel = StackModel()
      stackModel
         .set(.alignment(.leading))
         .set(.models([
            Spacer(size: 300),
           // BadgeModel()
            //   .set(.placing(.init(x: 0, y: -10))),
            viewModel
               // .set(.height(50))
               .set(.backColor(.lightGray)),
           // BadgeModel(),
            Spacer()
         ]))

      view = stackModel.view
      view.backgroundColor = .red
   }
}

let vc = VC()
nc.viewControllers = [vc]

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

//public protocol Combo {}
//
//public extension Combo {
//   var mainModel: Self { self }
//}
//
//public protocol ComboRight: Combo {
//   associatedtype RightModel: ViewModelProtocol
//
//   var rightModel: RightModel { get }
//}
//
//public extension ComboRight {
//   func setRight(_ closure: (RightModel) -> Void) -> Self {
//      closure(rightModel)
//      return self
//   }
//}
//
//public extension ViewModelProtocol where Self: ComboRight {
//   var uiView: UIView {
//      print("uiview")
//      let stackView = UIStackView()
//      stackView.axis = .horizontal
//      stackView.addArrangedSubview(view)
//      stackView.addArrangedSubview(rightModel.uiView)
//      return stackView
//   }
//}


// protocol ExtendableViewModel {
//   enum Side {
//      case left
//      case top
//      case right
//      case bottom
//   }
//   func extendSide(_ side: Side, by model: UIViewModel)
// }
// protocol HashableExtra: Hashable {}
//
// extension HashableExtra {
//   var caseName: String {
//      Mirror(reflecting: self).children.first?.label ?? String(describing: self)
//   }
//
//   func hash(into hasher: inout Hasher) {
//      hasher.combine(self.caseName)
//   }
// }
//
// extension HashableExtra {
//   static func == (lhs: Self, rhs: Self) -> Bool {
//      lhs.hashValue == rhs.hashValue
//   }
// }
//
// enum States: HashableExtra {
//   case normal
//   case selected
// }
//
// struct NormalStates<State> {
//   let normal: [State]
//   let selected: [State]
// }
//
// protocol StateMachine {
//   associatedtype State
//
//   var currentState: State { get }
//
//   func setState(_ state: State) -> Self
// }



//final class TripleViewModel: BaseViewModel<UIView>, Stateable {
//   typealias State = ViewState
//
////   var currentState: ViewState = .backColor(.red)
//
//   let leftModel = ViewModel()
//   let rightModel = ViewModel()
//}
//
//extension TripleViewModel: RightExtender, LeftExtender {
//
//}

//final class LogoUserNameModel: BaseViewModel<UIView>, Stateable {
//   typealias State = ViewState
//
////   var currentState: ViewState = .backColor(.red)
//
//   let rightModel = ViewModel()
//}
//
//extension LogoUserNameModel: RightExtender {}

// extension TripleViewModel: StateMachine {
//   func setState(_ state: ViewState) -> Self {
//      return self
//   }
// }



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
