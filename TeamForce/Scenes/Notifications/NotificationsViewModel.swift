//
//  NotificationsViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import ReactiveWorks

final class NotificationsViewModel<Design: DSP>: StackModel, Designable {
   //
   private lazy var tableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)

   private lazy var presenter = HistoryPresenters<Design>()

   override func start() {
      super.start()

      arrangedModels([
         tableModel
      ])
   }
}

enum NotifyVMState {
   case tableData
}

extension NotificationsViewModel: StateMachine {
   func setState(_ state: NotifyVMState) {
      switch state {
      case .tableData:
         break
      }
   }
}
