//
//  ReactionButton.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks

final class ReactionButton<Design: DSP>: Combos<SComboMR<ImageViewModel, LabelModel>>, Designable {
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
}
