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
         .set(.backColor(.init(hue: .random(in: 0...1), saturation: 0.3, brightness: 0.8, alpha: 1)))
      let titleSubtitle = TitleSubtitleModel()
         .set(.text("Hello"))
         .set(.backColor(.init(hue: .random(in: 0...1), saturation: 0.3, brightness: 0.8, alpha: 1)))
         .setDown { subtitle in
            subtitle
               .set(.text("World"))
               .set(.backColor(.init(hue: .random(in: 0...1), saturation: 0.3, brightness: 0.8, alpha: 1)))
         }
      let logoTitleSubtitle = LogoTitleSubtitleModel()
         .set(.image(Design.icon.make(\.logo)))
         .set(.backColor(.init(hue: .random(in: 0...1), saturation: 0.3, brightness: 0.8, alpha: 1)))
         .setRight { titleSubtitle in
            titleSubtitle
               .set(.text("Hello"))
               .set(.backColor(.init(hue: .random(in: 0...1), saturation: 0.3, brightness: 0.8, alpha: 1)))
               .setDown { subtitle in
                  subtitle
                     .set(.text("World"))
                     .set(.backColor(.init(hue: .random(in: 0...1), saturation: 0.3, brightness: 0.8, alpha: 1)))
               }
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
            Spacer()
         ]))
   }
}

final class VizitkaDemo: BaseViewModel<UIView>, Stateable {
   typealias State = ViewState

   let rightModel = ViewModel()
      .set(.size(.init(width: 66, height: 100)))
      .set(.backColor(.yellow))

   let leftModel = ImageViewModel()
      .set(.size(.init(width: 100, height: 100)))
      .set(.backColor(.lightGray))
      .set(.image(ProductionAsset.Design.icon.make(\.logo)))

   let topModel = LabelModel()
      .set(.padding(.init(top: 0, left: 16, bottom: 0, right: 16)))
      .set(.numberOfLines(0))
      .set(.text("Full name and biography\nAnd many texts here"))
      .set(.backColor(.green))

   let downModel = ViewModel()
      .set(.height(33))
      .set(.backColor(.blue))
}

extension VizitkaDemo: ComboRight {} // try to off this
extension VizitkaDemo: ComboLeft {} // or this
extension VizitkaDemo: ComboDown {}
extension VizitkaDemo: ComboTop {}

final class ViewModel: BaseViewModel<UIView> {}
extension ViewModel: Stateable {
   typealias State = ViewState
}

protocol Cobinator {}
