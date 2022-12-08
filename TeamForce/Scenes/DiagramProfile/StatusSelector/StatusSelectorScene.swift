//
//  StatusSelectorScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

final class StatusSelectorScene<Asset: ASP>: BaseSceneModel<
   DefaultVCModel,
   ModalDoubleStackModel<Asset>,
   Asset,
   Void
>, Scenarible, Configurable {
   //
   private lazy var statusTable = TableItemsModel<Design>()
      .separatorStyle(.singleLine)
      .separatorColor(Design.color.iconMidpoint)
      .presenters(UserStatusPresenter<Design>.cellPresenter)

   lazy var scenario: Scenario = StatusSelectorScenario(
      works: StatusSelectorWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: StatusSelectorInputEvents(
         didSelectStatus: statusTable.on(\.didSelectRowInt)
      )
   )

   override func start() {
      vcModel?
         .on(\.viewDidLoad, self) {
            $0.configure()
         }
   }

   func configure() {
      mainVM.title.text("Статус")
      mainVM.closeButton.on(\.didTap, self) {
         $0.dismiss()
      }
      setState(.initial)
      scenario.start()
   }
}

enum StatusSelectorState {
   case initial
   case presentStatusList([UserStatus])
   case selectStatusAndDismiss(UserStatus)
}

extension StatusSelectorScene: StateMachine {
   func setState(_ state: StatusSelectorState) {
      switch state {
      case .initial:
         mainVM.bodyStack.arrangedModels(
            ActivityIndicatorSpacedBlock<Design>()
         )
      case .presentStatusList(let list):
         mainVM.bodyStack.arrangedModels(
            statusTable
         )
         statusTable.items(list)
      case .selectStatusAndDismiss(let status):
         completion?(status)
         dismiss()
      }
   }
}

struct UserStatusPresenter<Design: DSP> {
   static var cellPresenter: Presenter<UserStatus, UserStatusCell<Design>> {
      Presenter { work in
         let status = work.unsafeInput.item

         let cell = UserStatusCell<Design>()
         cell.icon.image(UserStatusFabric<Design>.icon(status))
         cell.label.text(UserStatusFabric<Design>.text(status))

         work.success(cell)
      }
   }
}

final class UserStatusCell<Design: DSP>: M<WrappedX<ImageViewModel>>.R<LabelModel>.R2<Spacer>.Combo {
   var icon: ImageViewModel { models.main.subModel }
   var label: LabelModel { models.right }

   required init() {
      super.init(isAutoreleaseView: true)

      setAll { iconWrapper, text, _ in
         iconWrapper
            .size(.square(50))
            .backColor(Design.color.backgroundInfoSecondary)
            .cornerRadius(50 / 2)
            .alignment(.center)
         iconWrapper.subModel
            .size(.square(24))
         text
            .set(Design.state.label.subtitle)
      }
      spacing(16)
      padding(.init(top: 10, left: 0, bottom: 10, right: 0))
   }
}

import UIKit

struct UserStatusFabric<Design: DSP> {
   static func text(_ status: UserStatus) -> String {
      switch status {
      case .office:
         return "В офисе"
      case .vacation:
         return "В отпуске"
      case .remote:
         return "На удаленке"
      case .sickLeave:
         return "На больничном"
      }
   }

   static func icon(_ status: UserStatus) -> UIImage {
      switch status {
      case .office:
         return Design.icon.tablerBuildingArch
      case .vacation:
         return Design.icon.tablerDevicesPc
      case .remote:
         return Design.icon.tablerAerialLift
      case .sickLeave:
         return Design.icon.tablerHeartbeat
      }
   }
}
