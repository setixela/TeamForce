//
//  FeedDetailViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 26.09.2022.
//

import ReactiveWorks
import UIKit

final class FeedDeatilViewModel<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   Feed
> {
   private lazy var input: Feed? = nil
   typealias State = StackState


   // MARK: - Services

   override func start() {
      configure()
      configureLabels()
   }

   private lazy var image = WrappedY(ImageViewModel()
      .image(Design.icon.avatarPlaceholder)
      .contentMode(.scaleAspectFill)
      .cornerRadius(70 / 2)
      .size(.square(70))
      .shadow(Design.params.cellShadow)
   )

   private func configure() {
      mainVM.headerStack.arrangedModels([Grid.x64.spacer])
      mainVM.bodyStack
         .set(Design.state.stack.default)
         .alignment(.center)
         .set(.backColor(Design.color.backgroundSecondary))
         .arrangedModels([
            
         ])
   }

   private func configureLabels() {
      guard let input = self.inputValue else { return }
      print("from detail \(input)")
      
   }
}

