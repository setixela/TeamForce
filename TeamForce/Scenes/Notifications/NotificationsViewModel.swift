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

struct NotificationsPresenter<Design: DSP>: Designable {
   var notifyCell: Presenter<TransactionItem, HistoryCellModel<Design>> {
      Presenter { work in
         let item = work.unsafeInput.item
      }
   }
}

final class NotificationsCellModel<Design: DSP>:
   Main<ImageViewModel>.Right<LabelModel>.Down<LabelModel>.Combo,
   Designable
{

   var icon: ImageViewModel { models.main }
   var date: LabelModel { models.right }
   var type: LabelModel { models.down }

   required init() {
      super.init(isAutoreleaseView: true)

      setAll { icon, date, notify in

      }
   }
}

extension NotificationsCellModel: SetupProtocol {
   func setup(_ data: Notification) {
      switch data.type {
      case .T:
         type.text("Создан новый перевод")
      case .C:
         type.text("Добавлен комментарий")
      case .L:
         type.text("Добавлен лайк")
      case .W:
         type.text("Пользователь победил в челлендже")
      case .R:
         type.text("Пользователь выполнил челлендж")
      default:
         break
      }
   }
}

