//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
import UIKit

func example(_ name: String = "", action: () -> Void) {
   print("\n--- Example \(name):")
   action()
}

if true {
   let nc = UINavigationController()
   nc.view.frame = CGRect(x: 0, y: 0, width: 360, height: 640)
   PlaygroundPage.current.liveView = nc

   ///////// """ STATEABLE -> PARAMETRIC """

   ///// MARK: - СДЕЛАТЬ АНИМАЦИЮ ПОЯВЛЕНИЯ БЛОКОВ

   class VC: UIViewController {
      override func loadView() {
//         view = scene.makeMainView()
//         view = UIView()
         view = model.uiView
      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}

// let scene = MainScene<ProductionAsset>()
let model = TransactOptions<ProductionAsset.Design>()

// MARK: - Experiments --------------------------------------------------------------

final class TransactOptions<Design: DSP>: BaseViewModel<StackViewExtended>, Designable, Stateable {
   typealias State = StackState
   //
   private lazy var anonimParamModel = LabelSwitcherX.switcherWith(text: "Hello")

   private lazy var showEveryoneParamModel = LabelSwitcherX.switcherWith(text: "World")

   private lazy var addTagParamModel = LabelSwitcherX.switcherWith(text: "Hello")

   private lazy var whishParamModel = LabelSwitcherX.switcherWith(text: "Word")

   override func start() {
      set_arrangedModels([
         anonimParamModel,
         showEveryoneParamModel,
         addTagParamModel,
         whishParamModel
      ])
   }
}

final class LabelSwitcherX: Combos<SComboMR<LabelModel, WrappedY<Switcher>>> {
   var label: LabelModel { models.main }
   var switcher: Switcher { models.right.subModel }

   override func start() {
      set_alignment(.center)
      set_axis(.horizontal)
   }
}

extension LabelSwitcherX {
   static func switcherWith(text: String) -> Self {
      Self()
         .setAll { label, _ in
            label.set_text(text)
         }
   }
}

struct SwitchEvent: InitProtocol {
   var turnedOn: Event<Void>?
   var turnedOff: Event<Void>?
}

enum SwitcherState {
   case turnOn
   case turnOff
}

final class Switcher: BaseViewModel<UISwitch>, Communicable, Stateable2 {
   typealias State = ViewState
   typealias State2 = SwitcherState

   var events = SwitchEvent()

   override func start() {
      view.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
   }

   @objc private func didSwitch() {
      if view.isOn {
         sendEvent(\.turnedOn)
      } else {
         sendEvent(\.turnedOff)
      }
   }
}

extension Switcher {
   func applyState(_ state: SwitcherState) {
      switch state {
      case .turnOn:
         view.setOn(true, animated: true)
      case .turnOff:
         view.setOn(false, animated: true)
      }
   }
}
