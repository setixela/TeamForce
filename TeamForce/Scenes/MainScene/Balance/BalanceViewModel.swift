//
//  BalanceViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import CoreFoundation
import ReactiveWorks
import UIKit

///////// """ STATEABLE -> PARAMETRIC """

final class BalanceScene<Asset: AssetProtocol>: BaseViewModel<StackViewExtended>,
   Communicable,
   Stateable,
   Assetable,
   Scenarible
{
   typealias State2 = ViewState
   typealias State = StackState

   lazy var scenario: Scenario = BalanceScenario(
      works: BalanceWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: BalanceScenarioInputEvents()
   )

   var events: MainSceneEvents = .init()

   // MARK: - Frame Cells

   private lazy var selectPeriod = LabelIconX<Design>(Design.state.stack.buttonFrame)
      .set {
         $0.label
            .set_text(Text.title.selectPeriod)
            .set_textColor(Design.color.textSecondary)
         $0.iconModel
            .set_image(Design.icon.calendarLine)
            .set_imageTintColor(Design.color.iconBrand)
      }

   private lazy var myAccountFrame = FrameCellModelDT<Design>()
      .set(.backColor(Design.color.frameCellBackground))
      .set(.header(Text.title.myAccount))

   private lazy var leftToSendFrame = FrameCellModelDT<Design>()
      .set(.header(Text.title.leftToSend))
      .set(.borderWidth(1))
      .set(.backColor(Design.color.frameCellBackgroundSecondary))
      .set(.borderColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))

   private lazy var frameCellStackModel = WrappedX(
      ScrollViewModelX()
         .set(.hideHorizontalScrollIndicator)
         .set(.models([
            Grid.x16.spacer,
            myAccountFrame,
            Grid.x16.spacer,
            leftToSendFrame,
            Grid.x16.spacer,
         ]))
   )
   .set_padding(.init(top: 0, left: -16, bottom: 0, right: -16))
   .set_height(184)

   private lazy var annulationFrame = BalanceStatusFrameDT<Design>()
      .setMain {
         $0
            .set_image(Design.icon.cross)
            .set_imageTintColor(Design.color.textError)
      } setRight: {
         $0
            .set_text("Аннулировано")
            .set_textColor(Design.color.textError)
      } setDown: {
         $0
            .set_text("0")
      }
      .set_backColor(Design.color.errorSecondary)

   private lazy var inProgessFrame = BalanceStatusFrameDT<Design>()
      .setMain {
         $0
            .set_image(Design.icon.inProgress)
            .set_imageTintColor(Design.color.success)
      } setRight: {
         $0
            .set_text("На согласовании")
            .set_textColor(Design.color.success)
      } setDown: {
         $0
            .set_text("0")
      }
      .set_backColor(Design.color.successSecondary)

   // MARK: - Services

   private lazy var useCase = Asset.apiUseCase

   private var balance: Balance?

   override func start() {
      set(.axis(.vertical))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set(.models([
         selectPeriod,
         Spacer(20),
         frameCellStackModel,
         Spacer(27),
         annulationFrame,
         Spacer(8),
         inProgessFrame,
         Grid.xxx.spacer,
      ]))
   }
}

extension BalanceScene {
   private func setBalance(_ balance: Balance) {
      setIncome(balance.income)
      setDistr(balance.distr)

      let frozenSum = balance.income.frozen + balance.distr.frozen
      let cancelledSum = balance.income.cancelled + balance.distr.cancelled

      annulationFrame.models.down
         .set_text("\(cancelledSum)")
      inProgessFrame.models.down
         .set_text("\(frozenSum)")
   }

   private func setIncome(_ income: Income) {
      myAccountFrame
         .set(.text(String(income.amount)))
         .set(.caption("\(Text.title.sended)): \(income.sent)"))
   }

   private func setDistr(_ distr: Distr) {
      leftToSendFrame
         .set(.text(String(distr.amount)))
         .set(.caption("\(Text.title.sended)): \(distr.sent)"))
   }
}

enum BalanceSceneState {
   case balanceDidLoad(Balance)
   case loadBalanceError
}

extension BalanceScene: StateMachine {
   func setState(_ state: BalanceSceneState) {
      switch state {
      case .balanceDidLoad(let balance):
         setBalance(balance)
      case .loadBalanceError:
         log("Balance Error!")
      }
   }
}
