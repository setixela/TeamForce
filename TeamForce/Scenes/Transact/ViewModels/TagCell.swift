//
//  TagCell.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.09.2022.
//

import ReactiveWorks

final class TagCell<Design: DSP>: IconTitleX, Designable {
   private let badgeImage = ImageViewModel()
      .size(.square(24))
//      .image(Design.icon.tablerCircleCheck)
      .backColor(Design.color.background)
      .imageTintColor(Design.color.iconBrand)
      .cornerRadius(24 / 2)
      .hidden(true)

   override func start() {
      super.start()

      backColor(Design.color.background)
      label.set(Design.state.label.body1)

      icon.view.clipsToBounds = false
      icon.view.layer.shouldRasterize = true
      icon.addModel(badgeImage) {
         $0
            .constSquare(size: 24)
            .fitToBottomRight($1)
      }
   }
}

extension TagCell: StateMachine {
   func setState(_ state: SelectState) {
      switch state {
      case .none:
         icon.borderWidth(0)
         icon.borderColor(Design.color.transparent)
         badgeImage.hidden(true)
      case .selected:

         icon.borderWidth(2)
         icon.borderColor(Design.color.iconBrand)

         badgeImage.hidden(false)
      }
   }
}
