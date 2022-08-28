//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks
import Foundation

final class FeedFilterButtons<Design: DSP>: StackModel, Designable {
   lazy var buttonAll = SecondaryButtonDT<Design>()
      .set_title("Все")
      .onEvent(\.didTap) { [weak self] in
         self?.select(0)
      }

   lazy var buttonMy = SecondaryButtonDT<Design>()
      .set_title("Мои")
      .onEvent(\.didTap) { [weak self] in
         self?.select(1)
      }

   lazy var buttonPublic = SecondaryButtonDT<Design>()
      .set_title("Публичные")
      .onEvent(\.didTap) { [weak self] in
         self?.select(2)
      }

   lazy var buttonCalendar = SecondaryButtonDT<Design>()
      .set_image(Design.icon.calendar)
      .set_width(52)
      .set_backColor(Design.color.backgroundBrandSecondary)
      .onEvent(\.didTap) { [weak self] in
         self?.select(3)
      }

   override func start() {
      set_axis(.horizontal)
      set_spacing(Grid.x8.value)
      set_padBottom(8)
      set_arrangedModels([
         buttonAll,
         buttonMy,
         buttonPublic,
         Grid.xxx.spacer,
         buttonCalendar
      ])
   }

   private func deselectAll() {
      buttonAll.setMode(\.normal)
      buttonMy.setMode(\.normal)
      buttonPublic.setMode(\.normal)
   }

   private func select(_ index: Int) {
      deselectAll()
      switch index {
      case 1:
         buttonMy.setMode(\.selected)
      case 2:
         buttonPublic.setMode(\.selected)
      case 3:
         buttonCalendar.setMode(\.selected)
      default:
         buttonAll.setMode(\.selected)
      }
   }
}
