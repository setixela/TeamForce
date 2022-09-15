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
   lazy var addTagParamModel = SwitcherBox<SelectTagButton<Design>, Design>()
      .setAll { switcher, option in
         switcher.label.text("Добавить ценность")
         option.button.label.text("Выберите ценность")
      }

//   private lazy var showEveryoneParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Показать всем")
//   private lazy var awaitOptionsModel = TitleBodySwitcherDT<Design>.switcherWith(
//      titleText: "Период задержки",
//      bodyText: "Без задержки"
//   )
//   .backColor(Design.color.backgroundInfoSecondary)
//   .cornerRadius(Design.params.cornerRadius)

   override func start() {
      arrangedModels([
         anonimParamModel,
         addTagParamModel
      ])
   }
}

extension TagList: Eventable {
   struct Events: InitProtocol {
      var didSelectTag: Tag?
      var didDeselectTag: Tag?
   }
}

final class TagList<Asset: AssetProtocol>: ModalDoubleStackModel<Asset> {
   var events: EventsStore = .init()

   let useCase = Asset.apiUseCase
   let storageUseCase = Asset.storageUseCase

   private lazy var tableModel = TableItemsModel<Design>()
      .set(.presenters([
         tagPresenter
      ]))

   private var items: [SelectWrapper<Tag>] = []

   override func start() {
      super.start()

      title.text("Ценности")
      bodyStack
         .arrangedModels([
            tableModel
         ])

      loadTags()

      tableModel.on(\.didSelectRow, self) { slf, row in
         var item = slf.items[row.1]
         item.isSelected = !item.isSelected
         slf.items[row.1] = item
         slf.tableModel.set(.items(slf.items))

         if item.isSelected {
            slf.send(\.didSelectTag, item.value)
         } else {
            slf.send(\.didDeselectTag, item.value)
         }
      }
   }

   private func loadTags() {
      storageUseCase.loadToken
         .doAsync()
         .doNext(useCase.getTags)
         .onSuccess(self) {
            $0.items = $1.map {
               SelectWrapper(value: $0)
            }
            $0.setItemsToTable()
         }
         .onFail(self) {
            $0.items = []
            $0.setItemsToTable()
         }
   }

   private func setItemsToTable() {
      tableModel.set(.items(items))
   }

   private var tagPresenter: Presenter<SelectWrapper<Tag>, TagCell<Design>> = .init { work in
      let isSelected = work.unsafeInput.isSelected
      let tag = work.unsafeInput.value
      let iconLabel = TagCell<Design>()
         .setAll { icon, label in
            icon
               .size(.square(50))
               .cornerRadius(50 / 2)
               .backColor(Design.color.backgroundInfoSecondary)
               .contentMode(.scaleAspectFit)
               .image(Design.icon.tablerDiamond.withInset(.outline(5)))
               .imageTintColor(Design.color.iconBrand)

            label
               .padLeft(16)
               .text(tag.name.string)
               .backColor(Design.color.background)
               .height(70)
         }
         .alignment(.center)
         .height(70)
      iconLabel.setState(isSelected ? .selected : .none)

      work.success(result: iconLabel)
   }
}

enum TagListState {
   case clear
}

extension TagList: StateMachine {
   func setState(_ state: TagListState) {
      switch state {
      case .clear:
         items = []
         setItemsToTable()
         loadTags()
      }
   }
}

struct SelectWrapper<T> {
   let value: T
   var isSelected = false
}

final class TagCell<Design: DSP>: IconTitleX, Designable {
   override func start() {
      super.start()

      backColor(Design.color.background)
      label.set(Design.state.label.body1)
   }
}

extension TagCell: StateMachine {
   func setState(_ state: SelectState) {
      switch state {
      case .none:
         icon.borderWidth(0)
         icon.borderColor(Design.color.transparent)
      case .selected:
         icon.borderWidth(2)
         icon.borderColor(Design.color.iconBrand)
      }
   }
}

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
