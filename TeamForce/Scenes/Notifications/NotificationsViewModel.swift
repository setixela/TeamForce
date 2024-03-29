//
//  NotificationsViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.11.2022.
//

import ReactiveWorks

final class NotificationsViewModel<Design: DSP>: StackModel, Designable {
   var events = EventsStore()
   //
   private lazy var tableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .separatorColor(Design.color.cellSeparatorColor)
      .separatorStyle(.singleLine)
      .presenters(
         NotificationsPresenter<Design>.notifyCell
      )

   override func start() {
      super.start()

      arrangedModels([
         tableModel
      ])

      tableModel.on(\.didSelectRowInt, self) {
         $0.send(\.didSelectRow, $1)
      }
   }
}

extension NotificationsViewModel: Eventable {
   struct Events: InitProtocol {
      var didSelectRow: Int?
   }
}

enum NotifyVMState {
   case tableData([TableItemsSection])
}

extension NotificationsViewModel: StateMachine {
   func setState(_ state: NotifyVMState) {
      switch state {
      case .tableData(let sections):
         tableModel.itemSections(sections)
      }
   }
}

struct NotificationsPresenter<Design: DSP>: Designable {
   static var notifyCell: Presenter<Notification, NotificationsCellModel<Design>> {
      Presenter { work in
         let item = work.unsafeInput.item

         let cell = NotificationsCellModel<Design>()
         cell.setup(item)

         work.success(cell)
      }
   }
}

final class NotificationsCellModel<Design: DSP>:
   Main<WrappedX<ImageViewModel>>.Right<LabelModel>
   .Down<LabelModel>.Combo,
   //
   Designable
{
   //
   var iconPlace: StackModel { models.main }
   var icon: ImageViewModel { models.main.subModel }
   var date: LabelModel { models.right }
   var type: LabelModel { models.down }

   private lazy var typeIcon = ImageViewModel()
      .size(.square(13))

   private lazy var typeIconWrapper = WrappedX(typeIcon)
      .backColor(Design.color.background)
      .cornerRadius(21/2)
      .size(.square(21))
      .alignment(.center)
      .distribution(.equalCentering)

   required init() {
      super.init(isAutoreleaseView: true)

      setAll { icon, date, notify in
         //
         icon
            .size(.square(36))
            .cornerRadius(36/2)
         //
         date
            .set(Design.state.label.captionSecondary)
         //
         notify
            .set(Design.state.label.caption)
      }

      iconPlace
         .addModel(typeIconWrapper) { anchors, view in
            anchors
               .centerX(view.centerXAnchor, 36/3)
               .centerY(view.centerYAnchor, -36/3)
         }

      padding(.outline(16))
      spacing(12)
   }
}

extension NotificationsCellModel: SetupProtocol {
   func setup(_ data: Notification) {
//
      icon
         .image(Design.icon.anonAvatar)
         .imageTintColor(Design.color.iconBrand)
      date.text(data.updatedAt?.timeAgoConverted ?? "")
      type.text(data.theme)

      switch data.type {
      case .transactAdded:
         typeIcon.image(Design.icon.tablerBrandTelegram)
      case .commentAdded:
         typeIcon.image(Design.icon.tablerMessageCircle)
      case .likeAdded:
         typeIcon.image(Design.icon.like)
      case .challengeWin:
         typeIcon.image(Design.icon.tablerMessageCircle)
      case .finishedChallenge:
         typeIcon.image(Design.icon.tablerUserCheck)
      case .challengeCreated:
         typeIcon.image(Design.icon.tablerMoodSmile)
      }
   }
}
