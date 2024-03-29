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
   var currencyLogo: ImageViewModel { models.right }

   required init() {
      super.init()

      setAll {
         $0
            .set(Design.state.label.title2)
            .text("0")
            .textColor(Design.color.iconInvert)
         $1
            .image(Design.icon.logoCurrency)
            .imageTintColor(Design.color.iconInvert)
      }
      axis(.horizontal)
   }
}


