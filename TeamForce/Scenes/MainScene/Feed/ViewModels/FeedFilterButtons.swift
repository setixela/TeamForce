//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation
import ReactiveWorks

final class FeedFilterButtons<Design: DSP>: StackModel, Designable, Communicable {
   struct Events: InitProtocol {
      var didTapAll: Event<Void>?
      var didTapMy: Event<Void>?
      var didTapPublic: Event<Void>?
   }

   var events: Events = .init()

   lazy var buttonAll = SecondaryButtonDT<Design>()
      .title("Все")
      .onEvent(\.didTap) { [weak self] in
         self?.select(0)
         self?.sendEvent(\.didTapAll)
      }

   lazy var buttonMy = SecondaryButtonDT<Design>()
      .title("Мои")
      .onEvent(\.didTap) { [weak self] in
         self?.select(1)
         self?.sendEvent(\.didTapMy)
      }

   lazy var buttonPublic = SecondaryButtonDT<Design>()
      .title("Публичные")
      .onEvent(\.didTap) { [weak self] in
         self?.select(2)
         self?.sendEvent(\.didTapPublic)
      }

   lazy var buttonCalendar = SecondaryButtonDT<Design>()
      .image(Design.icon.calendar)
      .width(52)
      .backColor(Design.color.backgroundBrandSecondary)
      .onEvent(\.didTap) { [weak self] in
         self?.select(3)
      }

   override func start() {
      axis(.horizontal)
      spacing(Grid.x8.value)
      padBottom(8)
      arrangedModels([
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
