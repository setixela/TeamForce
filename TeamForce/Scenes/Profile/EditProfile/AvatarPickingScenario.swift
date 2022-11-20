//
//  AvatarPickingScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.09.2022.
//

import UIKit

struct AvatarPickingScenarioEvents {
   let startImagePicking: WorkVoidVoid
   let addImageToBasket: WorkVoid<UIImage>
   let saveCroppedImage: WorkVoid<UIImage>
}

final class AvatarPickingScenario<Asset: AssetProtocol>:
   BaseScenario<AvatarPickingScenarioEvents, ProfileEditState, ProfileEditWorks<Asset>>
{
   override func start() {
      events.startImagePicking
         .onSuccess(setState, .presentImagePicker)

      events.addImageToBasket
         .doNext(works.addImage)
         .onSuccess(setState) { .presentPickedImage($0) }
      
      events.saveCroppedImage
         .doNext(works.saveCroppedImage)
         .onSuccess(setState) {
            .presentPickedImage($0)
         }
   }
}
