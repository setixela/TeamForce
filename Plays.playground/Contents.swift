//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
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
         view = StackModel().uiView

      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}



