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
   private lazy var activity = ActivityIndicator<Design>()

   override func start() {
      super.start()

      vcModel?.on(\.viewDidLoad, self) {
         $0.mainVM.backColor(Design.color.background)
         $0.scrollModel.setState(.viewModel($0.image))

         $0.mainVM
            .arrangedModels([
               Spacer(16),
               $0.titlePanel,
            ])
            .backViewModel($0.scrollModel)
            .addModel($0.activity) { anchors, view in
               anchors
                  .centerX(view.centerXAnchor)
                  .centerY(view.centerYAnchor)
            }
      }

      on(\.input, self) { slf, url in
         slf.image.url(url) { [weak self] _, _ in
            self?.image.url(TeamForceEndpoints.removeThumbSuffix(url)) { [weak self] _, _ in
              self?.activity.hidden(true)
            }
         }
      }

      closeButton.on(\.didTap, self) {
         $0.dismiss()
         $0.finishCanceled()
      }

   }
}
