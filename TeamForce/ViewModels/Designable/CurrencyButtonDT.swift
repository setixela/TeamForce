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
      button.models.main.text(String(text))
      return button
   }
}

final class CurrencyButtonDT<Design: DSP>: CurrencyLabelDT<Design>, Eventable, Modable {

   typealias Events = ButtonEvents
   var events = [Int: LambdaProtocol?]()

   var modes = ButtonMode()

   var currencyValue = 0

   override func start() {
      setAll {
         $0.set(Design.state.label.body2)
         $1.width(Grid.x14.value)
      }

      height(Design.params.buttonSecondaryHeight)
      cornerRadius(Design.params.cornerRadiusMini)
      padding(.sideOffset(Grid.x10.value))
      onModeChanged(\.normal) { [weak self] in
         self?.backColor(Design.color.backgroundBrandSecondary)
         self?.label.textColor(Design.color.textError)
         self?.models.right.imageTintColor(Design.color.textError)
      }
      onModeChanged(\.selected) { [weak self] in
         self?.backColor(Design.color.textError)
         self?.label.textColor(Design.color.backgroundSecondary)
         self?.models.right.imageTintColor(Design.color.backgroundSecondary)
      }
      setMode(\.normal)
      view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
   }

   @objc private func didTap() {
      send(\.didTap)
      animateTapWithShadow()
   }
}

