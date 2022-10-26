//
//  ImageViewerScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.10.2022.
//

import ReactiveWorks

final class ImageViewerScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackModel,
   Asset,
   String
> {
   //
   private lazy var closeButton = ButtonModel()
      .title(Design.Text.title.close)
      .textColor(Design.color.textBrand)

   private lazy var titlePanel = Wrapped3X(
      Spacer(),
      closeButton,
      Spacer(16)
   )
   .height(64)
   .alignment(.top)

   private lazy var image = ImageViewModel()
      .contentMode(.scaleAspectFit)

   private lazy var scrollModel = ScrollViewModel()

   override func start() {
      super.start()

      on(\.input, self) {
         print($0, $1)
         $0.image.url($1)
      }

      closeButton.on(\.didTap, self) {
         $0.dismiss()
         $0.finisher?(true)
      }

      mainVM.backColor(Design.color.background)

      scrollModel.setState(.viewModel(image))

      mainVM
         .arrangedModels([
            Spacer(16),
            titlePanel
         ])
         .backViewModel(scrollModel)
   }
}
