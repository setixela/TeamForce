//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import ReactiveWorks
import UIKit

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
         let stack = StackModel()
            .set_arrangedModels([
               Grid.x128.spacer,
               model,
               Grid.x128.spacer,
               Grid.xxx.spacer
            ])
         view = stack.uiView
      }
   }

   let vc = VC()
   nc.viewControllers = [vc]
} else {
   PlaygroundPage.current.needsIndefiniteExecution = true
}

// let scene = MainScene<ProductionAsset>()

let model = Combos<SComboMD<LabelModel, IconTextField<Design>>>()
   .setAll { topBadge, inputField in
      inputField.setAll {
         $0
            .set_image(Design.icon.user)
         $1
            .set_placeholder(Text.title.userName)
            .set_placeholderColor(Design.color.textFieldPlaceholder)
      }
      topBadge
        // .set_placing(.init(x: 0, y: 0))
        // .set_padLeft(0)
         .set(Design.state.label.captionError)
         .set_text("Error")
         .set_zPosition(1000)
   }
