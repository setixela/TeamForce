//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks

final class SecondaryButtonDT<Design: DSP>: ButtonModel, Designable, Modable {
   var modes = ButtonMode()

   override func start() {
      super.start()

      set_padding(.sideOffset(Grid.x14.value))
      set_height(Design.params.buttonSecondaryHeight)
      set_cornerRadius(Design.params.cornerRadiusMini)
      set_shadow(Design.params.cellShadow)
      onModeChanged(\.normal) { [weak self] in
         self?.set_backColor(Design.color.background)
         self?.set_textColor(Design.color.text)
      }
      onModeChanged(\.selected) { [weak self] in
         self?.set_backColor(Design.color.backgroundBrand)
         self?.set_textColor(Design.color.textInvert)
      }
      setMode(\.normal)
   }
}
