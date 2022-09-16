//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.09.2022.
//

import ReactiveWorks

enum SelectState {
   case none
   case selected
}

final class SelectTagButton<Design: DSP>: M<ScrollViewModelX>.D<TitleIconX>.Combo, Designable {
   var events: EventsStore = .init()

   var button: TitleIconX { models.down }
   var selectedTagsPanel: ScrollViewModelX { models.main }

   required init() {
      super.init()

      setAll { tagsScrollView, titleIcon in
         tagsScrollView
            .set(.spacing(8))
            .set(.hideHorizontalScrollIndicator)
            .set(.padding(.bottom(16)))

         titleIcon
            .setAll { title, icon in
               title
                  .set(Design.state.label.default)
               icon
                  .size(.square(16))
                  .image(Design.icon.arrowDropRightLine)
            }
            .cornerRadius(Design.params.cornerRadiusSmall)
            .borderColor(Design.color.iconMidpoint)
            .borderWidth(1)
            .height(48)
            .distribution(.fill)
            .alignment(.center)
            .padding(.sideOffset(16))
      }
   }

   override func start() {
      super.start()

      view.didTapClosure = { [weak self] in
         self?.send(\.didTap)
      }
   }
}

enum SelectTagButtonState {
   case clear
   case selected([UIViewModel])
}

extension SelectTagButton: StateMachine {
   func setState(_ state: SelectTagButtonState) {
      switch state {
      case .clear:
         selectedTagsPanel.set(.arrangedModels([]))
         selectedTagsPanel.hidden(true)
         button.label.text("Выберите ценность")
      case .selected(let tags):
         selectedTagsPanel.set(.arrangedModels(tags))
         selectedTagsPanel.hidden(false)
         button.label.text("Добавлено \(tags.count) ценности. Добавить еще?")
      }
   }
}

extension SelectTagButton: Eventable {
   typealias Events = ButtonEvents
}
