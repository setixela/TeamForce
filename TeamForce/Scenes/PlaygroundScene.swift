//
//  PlaygroundScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 07.08.2022.
//

import ReactiveWorks
import UIKit

final class PlaygroundScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackModel,
   Asset,
   Void
> {
   override func start() {
      let viewModel = VizitkaDemo()
         .set(.size(.init(width: 150, height: 100)))

      let title = LabelModel()
         .set(.text("Hello"))
         .set(.backColor(.random))

      let titleSubtitle = TitleSubtitleModel()
         .set(.text("Hello"))
         .set(.backColor(.random))
         .setDown {
            $0
               .set(.text("World"))
               .set(.backColor(.random))
         }

      let logoTitleSubtitle = LogoTitleSubtitleModel()
         .set(.image(Design.icon.make(\.logo)))
         .set(.backColor(.random))
         .setRight {
            $0
               .set(.text("Hello"))
               .set(.backColor(.random))
               .setDown {
                  $0
                     .set(.text("World"))
                     .set(.backColor(.random))
               }
         }

      let comboC = Combos { (model: ViewModel) in
         model
            .set(.size(.square(60)))
            .set(.backColor(.random))
      } setRight: { (model: ViewModel) in
         model
            .set(.size(.square(30)))
            .set(.backColor(.random))
      } setDown: { (model: ViewModel) in
         model
            .set(.size(.square(30)))
            .set(.backColor(.random))
      }

      mainViewModel
         .set(.alignment(.leading))
         .set(.axis(.vertical))
         .set(.models([
            Spacer(150),
            viewModel.set(.backColor(.white)),
            Spacer(32),
            title,
            Spacer(32),
            titleSubtitle,
            Spacer(32),
            logoTitleSubtitle,
            Spacer(32),
            comboC,
            Spacer()
         ]))
   }
}

final class VizitkaDemo: BaseViewModel<PaddingLabel>, Stateable2 {
   typealias State = ViewState
   typealias State2 = LabelState

   let rightModel = ViewModel()
      .set(.size(.init(width: 66, height: 100)))
      .set(.backColor(.yellow))

   let leftModel = ImageViewModel()
      .set(.size(.init(width: 100, height: 100)))
      .set(.backColor(.lightGray))
      .set(.image(ProductionAsset.Design.icon.make(\.logo)))

   let topModel = LabelModel()
      .set(.padLeft(64))
      .set(.numberOfLines(0))
      .set(.text("Full name and biography\nAnd many texts here"))
      .set(.backColor(.green))

   let downModel = ViewModel()
      .set(.height(33))
      .set(.backColor(.blue))

   override func start() {
      set(.text("Main"))
   }
}

//
// extension Combo {
//   static func make() {}
// }

extension VizitkaDemo: ComboRight {} // try to off this
extension VizitkaDemo: ComboLeft {} // or this
extension VizitkaDemo: ComboDown {}
extension VizitkaDemo: ComboTop {}

final class ViewModel: BaseViewModel<UIView> {}
extension ViewModel: Stateable {
   typealias State = ViewState
}

final class Combinator<Main: InitProtocol
//   Left: InitProtocol,
//   Right: InitProtocol
//   Down: InitProtocol,
   //  Up: InitProtocol
> {
   enum Cases {
      case r // 1
      case d // 2
      case l // 3
      case t // 4
      case rd // 5
      case rl // 6
      case rt // 7
      case dl // 8
      case dt // 9
      case lt // 10
      case rdl // 11
      case rdt // 12
      case rlt // 12
      case dlt // 13
      case rdlt // 15
   }
}

extension UIColor {
   static var random: UIColor {
      .init(hue: .random(in: 0 ... 1), saturation: 0.5, brightness: 0.9, alpha: 1)
   }
}

extension CGSize {
   static func square(_ size: CGFloat) -> CGSize {
      .init(width: size, height: size)
   }
}
