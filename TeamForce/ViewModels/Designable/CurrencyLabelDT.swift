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

final class CurrencyButtonDT<Design: DSP>: CurrencyLabelDT<Design>, Communicable, Modable {
   var events = ButtonEvents()
   var modes = ButtonMode()

   override func start() {
      setAll {
         $0
            .set_font(Design.font.body2)
        //    .set_text("0")
          //  .set_color(Design.color.iconInvert)
            //.set_height(Grid.x20.value)
         $1
       //     .set_image(Design.icon.logoCurrency)
            .set_width(Grid.x14.value)
           // .set_imageTintColor(Design.color.iconInvert)
      }

      set_height(Design.params.buttonSecondaryHeight)
      set_cornerRadius(Design.params.cornerRadiusMini)
      set_padding(.sideOffset(Grid.x10.value))
      onModeChanged(\.normal) { [weak self] in
         self?.set_backColor(Design.color.backgroundBrandSecondary)
         self?.label.set_color(Design.color.textError)
         self?.models.right.set_imageTintColor(Design.color.textError)
      }
      onModeChanged(\.selected) { [weak self] in
         self?.set_backColor(Design.color.textError)
         self?.label.set_color(Design.color.backgroundSecondary)
         self?.models.right.set_imageTintColor(Design.color.backgroundSecondary)
      }
      setMode(\.normal)
      view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
   }

   @objc private func didTap() {
      sendEvent(\.didTap)
      animateTap()
   }
}
