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
   private lazy var showEveryoneParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Показать всем")
   private lazy var addTagParamModel = SwitcherBox<LabelModel, Design>()
      .setAll { switcher, option in
         switcher.label.text("Добавить ценность")
         option.text("TST")
      }

   private lazy var awaitOptionsModel = TitleBodySwitcherDT<Design>.switcherWith(titleText: "Период задержки",
                                                                                 bodyText: "Без задержки")
      .backColor(Design.color.backgroundInfoSecondary)
      .cornerRadius(Design.params.cornerRadius)

   override func start() {
      arrangedModels([
         anonimParamModel,
         addTagParamModel
      ])
   }
}

//final class TagList<Asset: AssetProtocol>: ModalDoubleStackModel<Asset> {
//   convenience init() {
//      <#statements#>
//   }
//}
