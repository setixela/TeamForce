//
//  CurrencyButtonDT.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import UIKit
import ReactiveWorks

extension CurrencyButtonDT {
   static func makeWithValue(_ text: Int) -> Self {
      let button = Self()
      button.currencyValue = text
      button.models.main.set_text(String(text))
      return button
   }
}

final class CurrencyButtonDT<Design: DSP>: CurrencyLabelDT<Design>, Communicable, Modable {
   var events = ButtonEvents()
   var modes = ButtonMode()

   var currencyValue = 0

   override func start() {
      setAll {
         $0.set_font(Design.font.body2)
         $1.set_width(Grid.x14.value)
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
      animateTapWithShadow()
   }
}

