//
//  TagCell.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.09.2022.
//

import ReactiveWorks

enum SelectState {
   case none
   case selected
}

final class TagCell<Design: DSP>: IconTitleX, Designable {
   private lazy var outline = ViewModel()
      .backColor(Design.color.transparent)
      .borderWidth(2)
      .borderColor(Design.color.iconBrand)
      .cornerRadius(50 / 2)
      .hidden(true)

   private lazy var badgeImage = ImageViewModel()
      .size(.square(24))
      .image(Design.icon.tablerCircleCheck)
      .backColor(Design.color.background)
      .imageTintColor(Design.color.iconBrand)
      .cornerRadius(24 / 2)
      .hidden(true)

   override func start() {
      super.start()

      backColor(Design.color.background)
      label.set(Design.state.label.body1)

      icon
         .size(.square(50))
         .cornerRadius(50 / 2)
         .backColor(Design.color.backgroundInfoSecondary)
         .contentMode(.scaleAspectFit)

      icon.view.clipsToBounds = false
      icon.view.layer.masksToBounds = false

      icon
         .addModel(outline) {
            $0
               .fitToView($1)
         }
         .addModel(badgeImage) {
            $0
               .constSquare(size: 24)
               .fitToBottomRight($1, offset: -4, sideOffset: -4)
         }

      icon.view.on(\.didTap) {

      }

      badgeImage.view.clipsToBounds = false
      badgeImage.view.layer.masksToBounds = false
   }
}

extension TagCell: StateMachine {
   func setState(_ state: SelectState) {
      switch state {
      case .none:
         icon.imageTintColor(Design.color.iconBrand)
         badgeImage.hidden(true)
         outline.hidden(true)
      case .selected:
         icon.imageTintColor(Design.color.iconContrast)
         outline.hidden(false)
         badgeImage.hidden(false)
      }
   }
}
