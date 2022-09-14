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
            .text(Text.title.selectPeriod)
            .textColor(Design.color.textSecondary)
         $0.iconModel
            .image(Design.icon.calendarLine)
            .imageTintColor(Design.color.iconBrand)
      }

   private lazy var myAccountFrame = FrameCellModelDT<Design>()
      .set(.backColor(Design.color.frameCellBackground))
      .set(.header(Text.title.myAccount))

   private lazy var leftToSendFrame = FrameCellModelDT<Design>()
      .set(.header(Text.title.leftToSend))
      .set(.borderWidth(1))
      .set(.backColor(Design.color.frameCellBackgroundSecondary))
      .set(.borderColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))

   private lazy var frameCellStackModel = StackModel()
      .axis(.horizontal)
      .distribution(.fillEqually)
      .spacing(Grid.x8.value)
      .arrangedModels([
         myAccountFrame,
         leftToSendFrame
      ])

   private lazy var annulationFrame = BalanceStatusFrameDT<Design>()
      .setMain {
         $0
            .image(Design.icon.cross)
            .imageTintColor(Design.color.textError)
      } setRight: {
         $0
            .text("Аннулировано")
            .textColor(Design.color.textError)
      } setDown: {
         $0
            .text("0")
      }
      .backColor(Design.color.errorSecondary)

   private lazy var inProgessFrame = BalanceStatusFrameDT<Design>()
      .setMain {
         $0
            .image(Design.icon.inProgress)
            .imageTintColor(Design.color.success)
      } setRight: {
         $0
            .text("На согласовании")
            .textColor(Design.color.success)
      } setDown: {
         $0
            .text("0")
      }
      .backColor(Design.color.successSecondary)

   // MARK: - Services

   private lazy var useCase = Asset.apiUseCase

   private var balance: Balance?

   override func start() {
      set(.axis(.vertical))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set(.arrangedModels([
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

      let frozenSum = balance.income.frozen
      let cancelledSum = balance.income.cancelled + balance.distr.cancelled

      annulationFrame.models.down
         .text("\(cancelledSum)")
      inProgessFrame.models.down
         .text("\(frozenSum)")
   }

   private func setIncome(_ income: Income) {
      myAccountFrame
         .set(.text(String(income.amount)))
         .set(.caption("\(Text.title.sended): \(income.sent)"))
   }

   private func setDistr(_ distr: Distr) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      var diffs = 0
      if let date1 = dateFormatter.date(from: distr.expireDate!) {
         let date2 = Date()
         diffs = Calendar.current.numberOf24DaysBetween(date2, and: date1)
      }
      
      leftToSendFrame
         .set(.text(String(distr.amount)))
         .set(.caption("\(Text.title.sended): \(distr.sent)"))
         .set(.burn("Cгорят через\n\(diffs) дня"))
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

extension Calendar {
   func numberOf24DaysBetween(_ from: Date, and to: Date) -> Int {
      let numberOfDays = dateComponents([.day], from: from, to: to)

      return numberOfDays.day! + 1
   }
}
