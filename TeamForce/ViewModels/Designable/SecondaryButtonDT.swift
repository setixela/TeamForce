//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks

final class SecondaryButtonDT<Design: DSP>: ModableButton, Designable {
   override func start() {
      super.start()

      padding(.horizontalOffset(Grid.x14.value))
      height(Design.params.buttonHeightSmall)
      cornerRadius(Design.params.cornerRadiusSmall)
      shadow(Design.params.cellShadow)
      onModeChanged(\.normal) { [weak self] in
         self?.backColor(Design.color.background)
         self?.textColor(Design.color.text)
      }
      onModeChanged(\.selected) { [weak self] in
         self?.backColor(Design.color.backgroundBrand)
         self?.textColor(Design.color.textInvert)
      }
      setMode(\.normal)
   }
}
