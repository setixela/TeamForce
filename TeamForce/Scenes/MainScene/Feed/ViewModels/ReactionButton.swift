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
         $0.set_size(.square(Grid.x16.value))
         $1.set(Design.state.label.caption2)
      }
      set_spacing(8)
      set_backColor(Design.color.backgroundInfoSecondary)
      set_cornerRadius(Design.params.cornerRadiusMini)
      set_height(26)
      set_padding(.sideOffset(8))
   }
}
