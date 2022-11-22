//
//  CreateChallengePanel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.11.2022.
//

import ReactiveWorks

final class ChallengesFilterButtons<Design: DSP>: StackModel, Designable {
   var events: EventsStore = .init()

   private lazy var filterButtons = SlidedIndexButtons<Button2Event>(buttons:
      SecondaryButtonDT<Design>()
         .title("Все")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Активные")
         .font(Design.font.default))

   override func start() {
      super.start()

      arrangedModels([
         filterButtons,
      ])

      filterButtons.on(\.didTapButtons, self) {
         switch $1 {
         case .didTapButton1:
            $0.send(\.didTapFilterAll)
         case .didTapButton2:
            $0.send(\.didTapFilterActive)
         }
      }
   }
}

extension ChallengesFilterButtons: Eventable {
   struct Events: InitProtocol {
      var didTapFilterAll: Void?
      var didTapFilterActive: Void?
   }
}
