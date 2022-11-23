//
//  ImageViewerScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 27.10.2022.
//

import ReactiveWorks
import UIKit

final class ImageViewerScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ViewModel,
   Asset,
   String
> {
   //
   private lazy var closeButton = ButtonModel()
      .title(Design.Text.title.close)
      .textColor(Design.color.textBrand)

   private lazy var titlePanel = StackModel(
      Spacer(16),
      shareButton,
      Spacer(),
      closeButton,
      Spacer(16)
   )
   .height(64)
   .axis(.horizontal)
   .alignment(.top)

   private lazy var image = ImageViewModel()
      .contentMode(.scaleAspectFit)

   private lazy var scrollModel = ScrollViewModel()
      .backColor(.black)

   private lazy var activity = ActivityIndicator<Design>()

   private lazy var shareButton = ButtonModel()
      .image(.init(systemName: "square.and.arrow.up")!)
      .tint(Design.color.iconBrand)
      .size(.square(32))

   private lazy var darkLoader = DarkLoaderVM<Design>()

   override func start() {
      super.start()

      vcModel?.on(\.viewDidLoad, self) {
         $0.mainVM.backColor(Design.color.background)
         $0.scrollModel
            .viewModel($0.image)

         $0.mainVM
            .addModel($0.scrollModel, setup: { anchors, superview in
               anchors.fitToView(superview)
            })
            .addModel($0.titlePanel, setup: { anchors, superview in
               anchors.fitToTop(superview, offset: 16)
            })
            .addModel($0.activity) { anchors, view in
               anchors
                  .centerX(view.centerXAnchor)
                  .centerY(view.centerYAnchor)
            }
      }

      on(\.input, self) { slf, url in
         slf.vcModel?.on(\.viewDidAppear) { [slf] in
            slf.image.url(url) { [weak self] _, _ in
               self?.image.url(TeamForceEndpoints.removeThumbSuffix(url)) { [weak self] _, image in
                  self?.activity.hidden(true)
                  self?.scrollModel
                     .zooming(min: 1, max: 4)
                     .doubleTapForZooming()

                  self?.shareButton.on(\.didTap) {
                     self?.presentSharing(image: image)
                  }
               }
            }
         }
      }

      closeButton.on(\.didTap, self) {
         $0.dismiss()
         $0.finishCanceled()
      }
   }

   private func presentSharing(image: UIImage?) {
      darkLoader.setState(.loading(onView: vcModel?.view))

      let imageToShare = [image]
      let activityViewController = UIActivityViewController(
         activityItems: imageToShare as [Any], applicationActivities: nil
      )
      activityViewController.popoverPresentationController?.sourceView = vcModel?.view

      activityViewController.excludedActivityTypes = [
         UIActivity.ActivityType.postToFacebook,
      ]
      vcModel?.present(activityViewController, animated: true) { [weak self] in
         self?.darkLoader.setState(.normal)
      }
   }
}
