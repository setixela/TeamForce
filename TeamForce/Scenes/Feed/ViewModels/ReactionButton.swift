//
//  ReactionButton.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks
import CoreFoundation

final class ReactionButton<Design: DSP>: M<ImageViewModel>.R<LabelModel>.Combo, Designable {
   required init() {
      super.init()

      setAll {
         $0.size(.square(Grid.x16.value))
         $1.set(Design.state.label.caption2)
      }
      distribution(.equalCentering)
      cornerRadius(Design.params.cornerRadiusMini)
      width(55)
      height(34)
      padding(.horizontalOffset(12))

      setState(.none)
   }
}

extension ReactionButton: StateMachine {
   func setState(_ state: SelectState) {
      switch state {
      case .none:
         models.main.imageTintColor(Design.color.iconContrast)
         models.right.textColor(Design.color.iconContrast)
         backColor(Design.color.backgroundInfoSecondary)
      case .selected:
         models.main.imageTintColor(Design.color.success)
         models.right.textColor(Design.color.success)
         backColor(Design.color.successSecondary)
      }
   }
}
