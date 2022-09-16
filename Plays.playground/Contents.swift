//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
import UIKit
@testable import TeamForce

typealias Design = ProductionAsset.Design
typealias Text = ProductionAsset.Design.Text

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

//         view = model.uiView
      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}

// let scene = MainScene<ProductionAsset>()

let model = TagCell<Design>()
//
final class TagCell<Design: DesignProtocol>: IconTitleX, Designable {
//   private let badgeImage = ImageViewModel()
//      .size(.square(24))
//      //      .image(Design.icon.tablerCircleCheck)
//      .backColor(Design.color.background)
//      .imageTintColor(Design.color.iconBrand)
//      .cornerRadius(24 / 2)
//      .hidden(true)
//
//   override func start() {
//      super.start()
//
//      backColor(Design.color.background)
//      label.set(Design.state.label.body1)
//
//      icon.view.clipsToBounds = false
//      icon.view.layer.shouldRasterize = true
//      icon.addModel(badgeImage) {
//         $0
//            .constSquare(size: 24)
//            .fitToBottomRight($1)
//      }
//   }
}

//extension TagCell: StateMachine {
//   func setState(_ state: SelectState) {
//      switch state {
//      case .none:
//         icon.borderWidth(0)
//         icon.borderColor(Design.color.transparent)
//         badgeImage.hidden(true)
//      case .selected:
//
//         icon.borderWidth(2)
//         icon.borderColor(Design.color.iconBrand)
//
//         badgeImage.hidden(false)
//      }
//   }
//}
