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
      set_axis(.horizontal)
      set_alignment(.leading)
      set_distribution(.equalSpacing)
      set_spacing(8)
   }

   func addButton(image: UIImage) {
      guard picked.count < maxCount else { return }

      let pickedImage = PickedImage<Design>()
      picked[image] = pickedImage
      pickedImage.image.set_image(image)

      set_arrangedModels(Array(picked.values))

      pickedImage.closeButton.onEvent(\.didTap) { [weak self] in
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
}

final class PickedImage<Design: DSP>: StackModel, Designable {
   let closeButton = ButtonModel()
      .set_image(Design.icon.cross.withTintColor(.white))
      .set_size(.square(23))

   let image = ImageViewModel()
      .set_size(.square(Grid.x80.value))
      .set_cornerRadius(Design.params.cornerRadius)

   override func start() {
      super.start()
      set_backColor(Design.color.background)
      set_axis(.horizontal)
      set_alignment(.top)
      set_size(.square(Grid.x80.value))
      set_cornerRadius(Design.params.cornerRadius)
      set_arrangedModels([
         Grid.xxx.spacer,
         closeButton
      ])
      set_backViewModel(image)
   }
}
