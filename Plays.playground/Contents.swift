//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
@testable import TeamForce
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
         view = UIView()

         let subview = UIView()
         subview.backgroundColor = .red
         subview.frame = .init(x: 100, y: 100, width: 100, height: 100)
         subview.layer.borderColor = UIColor.black.cgColor
         subview.layer.borderWidth = 3
         subview.layer.zPosition = -1


         let v2 = UIView()
         let v3 = UIView()
         v3.frame = .init(x: -10, y: -10, width: 30, height: 30)
         v2.backgroundColor = .lightGray
         v2.frame = .init(x: -10, y: -10, width: 30, height: 30)
       //  v2.layer.masksToBounds = true
       //  v2.layer.mask = v3.layer

         subview.addSubview(v2)
      //   subview.addSubview(v3)

//         view = model.uiView

         view.addSubview(subview)
      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}



