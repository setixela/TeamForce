//
//  PickedImagePanel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 02.09.2022.
//

import ReactiveWorks
import UIKit

struct PickedImagePanelEvents: InitProtocol {
   var didCloseImage: UIImage?
   var didMaximumReached: Void?
}

final class PickedImagePanel<Design: DSP>: StackModel, Designable, Eventable {
   typealias Events = PickedImagePanelEvents
   var events = [Int: LambdaProtocol?]()

   private var picked = [UIImage: UIViewModel]()

   private let maxCount = 1

   override func start() {
      axis(.horizontal)
      alignment(.leading)
      distribution(.equalSpacing)
      spacing(8)
   }

   func addButton(image: UIImage) {
      guard picked.count < maxCount else { return }

      let pickedImage = PickedImage<Design>()
      picked[image] = pickedImage
      pickedImage.image.image(image)

      arrangedModels(Array(picked.values))

      pickedImage.closeButton.on(\.didTap) { [weak self] in
         guard let self = self else { return }

         self.send(\.didCloseImage, image)
         let model = self.picked[image]
         model?.uiView.removeFromSuperview()
         self.picked[image] = nil
      }

      if picked.count >= maxCount {
         send(\.didMaximumReached)
      }
   }
   
   func clear() {
      picked.removeAll()
      arrangedModels([])
   }
}

final class PickedImage<Design: DSP>: StackModel, Designable {
   let closeButton = ButtonModel()
      .image(Design.icon.cross.withTintColor(.white))
      .size(.square(23))

   let image = ImageViewModel()
      .size(.square(Grid.x80.value))
      .cornerRadius(Design.params.cornerRadius)

   override func start() {
      super.start()
      backColor(Design.color.background)
      axis(.horizontal)
      alignment(.top)
      size(.square(Grid.x80.value))
      clipsToBound(true)
      cornerRadius(Design.params.cornerRadius)
      arrangedModels([
         Grid.xxx.spacer,
         closeButton
      ])
      backViewModel(image)
   }
}
