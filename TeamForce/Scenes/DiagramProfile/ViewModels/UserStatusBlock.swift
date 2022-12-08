//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - UserStatusBlock

final class UserStatusBlock<Design: DSP>: M<LabelModel>.R<LabelModel>.R2<ImageViewModel>.Combo,
                                          Designable
{
   var events: EventsStore = .init()

   required init() {
      super.init()

      setAll { title, status, icon in
         title
            .set(Design.state.label.body3)
            .textColor(Design.color.textInvert)
            .text("Статус")
         status
            .set(Design.state.label.default)
            .textColor(Design.color.textInvert)
         icon
            .size(.square(16))
            .image(Design.icon.tablerChevronRight, color: Design.color.iconInvert)
      }

      backColor(Design.color.backgroundBrand)
      cornerRadius(Design.params.cornerRadius)
      padding(.outline(16))
   }

   override func start() {
      view.startTapGestureRecognize()
      view.on(\.didTap, self) { $0.send(\.didTap) }
   }
}

extension UserStatusBlock: Eventable {
   typealias Events = TappableEvent
}

extension UserStatusBlock: StateMachine {
   func setState(_ state: UserStatus) {
      switch state {
      case .office:
         models.right.text("В офисе")
      case .vacation:
         models.right.text("В отпуске")
      case .remote:
         models.right.text("На удаленке")
      case .sickLeave:
         models.right.text("На больничном")
      }
   }
}
