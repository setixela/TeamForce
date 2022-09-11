//
//  AvatarPickingScenario.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.09.2022.
//

import UIKit

struct AvatarPickingScenarioEvents {
   let startImagePicking: VoidWorkVoid
   let addImageToBasket: VoidWork<UIImage>
}

final class AvatarPickingScenario<Asset: AssetProtocol>:
   BaseScenario<AvatarPickingScenarioEvents, ProfileEditState, ProfileEditWorks<Asset>>
{
   override func start() {
      events.startImagePicking
         .onSuccess(setState, .presentImagePicker)

      events.addImageToBasket
         .doNext(work: works.addImage)
         .onSuccess(setState) { .presentPickedImage($0) }
   }
}
