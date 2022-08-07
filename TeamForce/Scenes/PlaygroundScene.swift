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

      mainViewModel
         .set(.distribution(.equalCentering))
         .set(.alignment(.fill))
         .set(.axis(.vertical))
         .set(.models([
            Spacer(size: 300),
            viewModel.set(.backColor(.white)),
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
