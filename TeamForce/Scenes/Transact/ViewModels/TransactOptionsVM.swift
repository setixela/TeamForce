//
//  TransactOptions.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.08.2022.
//

import ReactiveWorks

final class TransactOptionsVM<Design: DSP>: BaseViewModel<StackViewExtended>, Designable, Stateable {
   typealias State = StackState
   //
   lazy var anonimParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Анонимно")
   lazy var tagsPanelSwitcher = SwitcherBox<TagsOptionsPanel<Design>, Design>()
      .setAll { switcher, option in
         switcher.label.text("Добавить ценность")
         option.button.label.text("Выберите ценность")
      }

   lazy var tagsCloud = TagsCloud<Design>()

//   private lazy var showEveryoneParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Показать всем")
//   private lazy var awaitOptionsModel = TitleBodySwitcherDT<Design>.switcherWith(
//      titleText: "Период задержки",
//      bodyText: "Без задержки"
//   )
//   .backColor(Design.color.backgroundInfoSecondary)
//   .cornerRadius(Design.params.cornerRadius)

   override func start() {
      arrangedModels([
         tagsCloud,
         anonimParamModel
      ])
   }
}

import UIKit

struct TagsCloudEvent: InitProtocol {
   var updateTags: Set<Tag>?
}

final class TagsCloud<Design: DSP>: StackModel, Designable, Eventable {
   typealias Events = TagsCloudEvent
   var events: EventsStore = .init()

   private var tags: [SelectWrapper<Tag>] = []

   override func start() {
      spacing(8)
      alignment(.leading)
   }

   private func tagBuild(icon: UIImage, name: String, isSelected: Bool) -> TagCloudButton<Design> {
      let button = TagCloudButton<Design>()
         .setAll { _, _ in
         }
      return button
   }
}

enum TagsCloudState {
   case items([SelectWrapper<Tag>])
}

extension TagsCloud: StateMachine {
   func setState(_ state: TagsCloudState) {
      switch state {
      case .items(let tags):
         self.tags = tags

         var currStack = StackModel()
            .axis(.horizontal)
            .spacing(8)
         var tagButts: [UIViewModel] = []
         let width = view.frame.width / 1.5
         var currWidth: CGFloat = 0
         var spacing: CGFloat = 8

         tags.enumerated().forEach { ind, tag in
            let button = TagCloudButton<Design>()
               .setAll { icon, title in
                  icon.image(Design.icon.tablerDiamond)
                  title.text(tag.value.name.string)
               }

            button.view.startTapGestureRecognize()
            button.view.on(\.didTap, self) { [button] in
               let tag = $0.tags[ind]
               let isSelected = tag.isSelected
               $0.tags[ind].isSelected = !isSelected

               if !isSelected {
                  button.setState(.selected)
               } else {
                  button.setState(.none)
               }

               $0.send(
                  \.updateTags,
                  Set($0.tags
                     .filter(\.isSelected)
                     .map(\.value)
                  )
               )
               
            }
            currStack.addArrangedModels([button])
            self.view.layoutIfNeeded()
            let butWidth = button.uiView.frame.width

            currWidth += butWidth + spacing

            let isNotFit = currWidth > width
            if isNotFit ||
               (ind == tags.count - 1)
            {
               tagButts.append(currStack)
               currStack.removeLastModel()
               currStack = StackModel()
                  .axis(.horizontal)
                  .spacing(8)
               currStack.addArrangedModels([button])
               currWidth = 0
            }
         }

         arrangedModels(tagButts)
      }
   }
}

final class TagCloudButton<Design: DSP>: M<ImageViewModel>.R<LabelModel>.Combo, Designable {
   required init() {
      super.init()

      setAll {
         $0.size(.square(Grid.x16.value))
         $1.set(Design.state.label.caption)
      }
      spacing(4)
      backColor(Design.color.background)
      cornerRadius(Design.params.cornerRadiusSmall)
      height(32)
      padding(.sideOffset(8))
      borderColor(Design.color.iconBrand)
      borderWidth(1)
   }
}

extension TagCloudButton: StateMachine {
   func setState(_ state: SelectState) {
      switch state {
      case .none:
         backColor(Design.color.background)
         models.right.textColor(Design.color.text)
         models.main.imageTintColor(Design.color.iconContrast)
      case .selected:
         backColor(Design.color.backgroundBrand)
         models.right.textColor(Design.color.textInvert)
         models.main.imageTintColor(Design.color.iconInvert)
      }
   }
}
