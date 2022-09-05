//
//  ImagePickingScenario.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 05.09.2022.
//

import UIKit

struct ImagePickingScenarioEvents {
   let startImagePicking: VoidWorkVoid
   let addImageToBasket: VoidWork<UIImage>
   let removeImageFromBasket: VoidWork<UIImage>
   let didMaximumReach: VoidWork<Void>
}

final class ImagePickingScenario<Asset: AssetProtocol>:
   BaseScenario<ImagePickingScenarioEvents, TransactState, TransactWorks<Asset>>
{
   override func start() {
      events.startImagePicking
         .onSuccess(setState, .presentImagePicker)

      events.addImageToBasket
         .doNext(work: works.addImage)
         .onSuccess(setState) { .presentPickedImage($0) }

      events.removeImageFromBasket
         .doNext(work: works.removeImage)
         .onSuccess(setState, .setHideAddPhotoButton(false))

      events.didMaximumReach
         .onSuccess(setState, .setHideAddPhotoButton(true))
   }
}
