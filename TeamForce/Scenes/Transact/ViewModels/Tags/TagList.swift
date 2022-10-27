//
//  TagList.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.09.2022.
//

import ReactiveWorks

extension TagList: Eventable {
   struct Events: InitProtocol {
      var saveButtonDidTap: Set<Tag>?
      var exit: Void?
   }
}

final class TagList<Asset: AssetProtocol>: ModalDoubleStackModel<Asset> {
   var events: EventsStore = .init()

   private lazy var useCase = Asset.apiUseCase
   private lazy var storageUseCase = Asset.storageUseCase

   private lazy var tableModel = TableItemsModel<Design>()
      .set(.presenters([
         tagPresenter
      ]))

   private var items: [SelectWrapper<Tag>] = []
   private var selctedTags: Set<Tag> = []

    lazy var saveButton = Design.button.inactive
      .title("Применить")

   override func start() {
      super.start()

      title.text("Ценности")
      bodyStack
         .arrangedModels([
            tableModel
         ])
      footerStack
         .arrangedModels([
            saveButton,
         ])
         .padTop(16)

      loadTags()

      tableModel.on(\.didSelectRow, self) { slf, row in
         var item = slf.items[row.1]
         item.isSelected = !item.isSelected
         slf.items[row.1] = item
         slf.tableModel.set(.items(slf.items))

         if item.isSelected {
            slf.selctedTags.insert(item.value)
         } else {
            slf.selctedTags.remove(item.value)
         }

         slf.saveButton.set(Design.state.button.default)
      }

      saveButton.on(\.didTap, self) {
         $0.send(\.saveButtonDidTap, $0.selctedTags)
         $0.saveButton.set(Design.state.button.inactive)
         $0.send(\.exit)
      }
   }

   private func loadTags() {
      storageUseCase.loadToken
         .doAsync()
         .doNext(useCase.GetSendCoinSettings)
         .doMap {
            $0.tags
         }
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
      let isSelected = work.unsafeInput.0.isSelected
      let tag = work.unsafeInput.item.value
      let iconLabel = TagCell<Design>()
         .setAll { icon, label in
            icon
               .image(Design.icon.tablerDiamond.withInset(.outline(5)))
               .imageTintColor(Design.color.iconBrand)
            label
               .padLeft(16)
               .text(tag.name.string)
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
   case selectTags(Set<Tag>)
}

extension TagList: StateMachine {
   func setState(_ state: TagListState) {
      switch state {
      case .clear:
         items = []
         setItemsToTable()
         loadTags()
      case .selectTags(let tags):
         self.selctedTags = tags
         saveButton.set(Design.state.button.inactive)
         items = items.map {
            var wrappedTag = $0
            wrappedTag.isSelected = tags.contains(wrappedTag.value)
            return wrappedTag
         }
         setItemsToTable()
      }
   }
}
