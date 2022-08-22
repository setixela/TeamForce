//
//  CurrencyLabelDT.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import ReactiveWorks
import UIKit

class CurrencyLabelDT<Design: DSP>: Combos<SComboMR<LabelModel, ImageViewModel>>, Designable, ButtonTapAnimator {
   //
   var label: LabelModel { models.main }

   required init() {
      super.init()

      setAll {
         $0
            .set_font(Design.font.title2)
            .set_text("0")
            .set_color(Design.color.iconInvert)
            .set_height(Grid.x20.value)
         $1
            .set_image(Design.icon.logoCurrency)
            .set_width(Grid.x20.value)
            .set_imageTintColor(Design.color.iconInvert)
      }
      set_axis(.horizontal)
   }
}


