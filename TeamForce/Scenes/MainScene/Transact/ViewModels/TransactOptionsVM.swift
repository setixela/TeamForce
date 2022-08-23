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
   private lazy var addTagParamModel = LabelSwitcherXDT<Design>.switcherWith(text: "Добавить тег")

   private lazy var awaitOptionsModel = TitleBodySwitcherDT<Design>.switcherWith(titleText: "Период задержки",
                                                                                 bodyText: "Без задержки")
      .set_backColor(Design.color.backgroundInfoSecondary)
      .set_cornerRadius(Design.params.cornerRadius)

   override func start() {
      set_arrangedModels([
         anonimParamModel,
         showEveryoneParamModel,
         addTagParamModel,
         awaitOptionsModel,
      ])
   }
}
