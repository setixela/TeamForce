//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.09.2022.
//

import ReactiveWorks

final class TagsOptionsPanel<Design: DSP>: M<ScrollViewModelX>.D<TitleIconX>.Combo, Designable {
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

      view.on(\.didTap, self) {
         $0.send(\.didTap)
      }
      view.startTapGestureRecognize()
   }
}

enum SelectTagButtonState {
   case clear
   case selected(Set<Tag>)
}

extension TagsOptionsPanel: StateMachine {
   func setState(_ state: SelectTagButtonState) {
      switch state {
      case .clear:
         selectedTagsPanel.set(.arrangedModels([]))
         selectedTagsPanel.hidden(true)
         button.label.text("Выберите ценность")
      case .selected(let tags):
         selectedTagsPanel.set(.arrangedModels(mapTagsToModels(tags)))
         selectedTagsPanel.hidden(false)
         button.label.text("Добавлено \(tags.count) ценности. Добавить еще?")
      }
   }

   private func mapTagsToModels(_ tags: Set<Tag>) -> [UIViewModel] {
      tags.map { tag in
         let model = TitleIconX()
            .setAll { title, icon in
               title
                  .set(Design.state.label.caption2)
                  .textColor(Design.color.textBrand)
                  .text(tag.name.string)

               icon
                  .image(Design.icon.tablerMark)
                  .size(.init(width: 24, height: 12))
                  .imageTintColor(Design.color.iconBrand)

               icon.view
                  .on(\.didTap, self) {
                     $0.send(\.didTapTag, tag)
                  }
            }
            .cornerRadius(Design.params.cornerRadiusMini)
            .backColor(Design.color.backgroundBrandSecondary)
            .padding(.init(top: 8, left: 8, bottom: 8, right: 0))

         return model
      }
   }
}

extension TagsOptionsPanel: Eventable {
   struct Events: InitProtocol {
      var didTap: Void?
      var didTapTag: Tag?
   }
}
