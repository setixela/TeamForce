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
      spacing(8)
      backColor(Design.color.backgroundInfoSecondary)
      cornerRadius(Design.params.cornerRadiusMini)
      height(26)
      padding(.sideOffset(8))
   }
   
   init(height: Int) {
      super.init()
      setAll {
         $0.size(.square(Grid.x20.value))
         $1.set(Design.state.label.caption)
      }
      spacing(8)
      backColor(Design.color.backgroundInfoSecondary)
      cornerRadius(Design.params.cornerRadiusMini)
      padding(.sideOffset(32))
      self.height(CGFloat(height))
   }
}

extension ReactionButton: StateMachine {
   func setState(_ state: SelectState) {
      switch state {
      case .none:
         models.main.imageTintColor(Design.color.iconContrast)
      case .selected:
         models.main.imageTintColor(Design.color.activeButtonBack)
      }
   }
}
