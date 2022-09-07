//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import Foundation
import ReactiveWorks

final class FeedFilterButtons<Design: DSP>: StackModel, Designable, Eventable {
   struct Events: InitProtocol {
      var didTapAll: Void?
      var didTapMy: Void?
      var didTapPublic: Void?
   }

   var events = [Int: LambdaProtocol?]()

   lazy var buttonAll = SecondaryButtonDT<Design>()
      .title("Все")
      .on(\.didTap) { [weak self] in
         self?.select(0)
         self?.send(\.didTapAll)
      }

   lazy var buttonMy = SecondaryButtonDT<Design>()
      .title("Мои")
      .on(\.didTap) { [weak self] in
         self?.select(1)
         self?.send(\.didTapMy)
      }

   lazy var buttonPublic = SecondaryButtonDT<Design>()
      .title("Публичные")
      .on(\.didTap) { [weak self] in
         self?.select(2)
         self?.send(\.didTapPublic)
      }

   lazy var buttonCalendar = SecondaryButtonDT<Design>()
      .image(Design.icon.calendar)
      .width(52)
      .backColor(Design.color.backgroundBrandSecondary)
      .on(\.didTap) { [weak self] in
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
