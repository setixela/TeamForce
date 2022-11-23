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
   private let combo = ComboMRD()

   private let logoTitle = DTLogoTitleX<Design>()

   override func start() {
      let viewModel = VizitkaDemo()
         .backColor(.random)
         .size(.init(width: 100, height: 66))

      let titleSubtitle = TitleSubtitleModel()
         .text("Hello")
         .backColor(.random)
         .setDown {
            $0
               .text("World")
               .backColor(.random)
         }

      let logoTitleSubtitle = IconTitleSubtitleModel()
         .image(Design.icon.logo)
         .backColor(.random)
         .setRight {
            $0
               .text("Hello")
               .backColor(.random)
               .setDown {
                  $0
                     .text("World")
                     .backColor(.random)
               }
         }

      let comboC = Combos { (model: ViewModel) in
         model
            .size(.square(60))
            .backColor(.random)
      } setRight: { (model: ViewModel) in
         model
            .size(.square(30))
            .backColor(.random)
      } setDown: { (model: ViewModel) in
         model
            .size(.square(30))
            .backColor(.random)
      }

      mainVM
         .alignment(.leading)
         .axis(.vertical)
         .arrangedModels([
            Spacer(32),
            viewModel,
            Spacer(32),
            logoTitle,
            Spacer(32),
            titleSubtitle,
            Spacer(32),
            logoTitleSubtitle,
            Spacer(32),
            comboC,
            Spacer(32),
            combo,
            Spacer()
         ])
   }
}

final class VizitkaDemo: BaseViewModel<PaddingLabel>, Stateable2 {
   typealias State = ViewState
   typealias State2 = LabelState

   let rightModel = ViewModel()
      .set(.size(.init(width: 66, height: 100)))
      .set(.backColor(.yellow))

   let leftModel = ImageViewModel()
      .set(.size(.init(width: 33, height: 24)))
      .set(.backColor(.lightGray))

   let topModel = LabelModel()
      .set(.padLeft(16))
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

extension VizitkaDemo: ComboRight {} // try to off this
extension VizitkaDemo: ComboLeft {} // or this
extension VizitkaDemo: ComboDown {}
extension VizitkaDemo: ComboTop {}

class ViewModel: BaseViewModel<UIView> {}

extension ViewModel: Stateable {
   typealias State = ViewState
}

extension CGSize {
   static func square(_ size: CGFloat) -> CGSize {
      .init(width: size, height: size)
   }
}

final class ComboMRD: Combos<SComboMRD<LabelModel, LabelModel, LabelModel>> {
   override func start() {
      setMain { (model: LabelModel) in
         model
            .set(.size(.square(100)))
            .set(.backColor(.random))
            .set(.numberOfLines(0))
            .set(.padding(.outline(8)))
            .set(.text("MAIN (SOME VIEWMODEL)"))
      } setRight: { (model: LabelModel) in
         model
            //   .set(.size(.square(40)))
            .set(.backColor(.random))
            .set(.text("RIGHT (SOME VIEWMODEL)"))
      } setDown: { (model: LabelModel) in
         model
            .set(.backColor(.random))
            .set(.text("DOWN (SOME VIEWMODEL)"))
      }
   }
}

