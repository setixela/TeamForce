//
//  StackWithBottomPanelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

class DoubleStacksModel: BaseViewModel<StackViewExtended> {
   let bodyStack = StackModel(.axis(.vertical),
                              .alignment(.fill),
                              .distribution(.fill))
   let footerStack = StackModel(.axis(.vertical),
                                .alignment(.fill),
                                .distribution(.fill))

   override func start() {
      set(.axis(.vertical))
      set(.alignment(.fill))
      set(.distribution(.fill))
      set(.arrangedModels([
         bodyStack,
         footerStack
      ]))
   }
}

extension DoubleStacksModel: Stateable2 {
   typealias State = StackState
   typealias State2 = ViewState
}
