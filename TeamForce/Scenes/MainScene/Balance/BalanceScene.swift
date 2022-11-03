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
   Eventable,
   Stateable,
   Assetable,
   Scenarible
{
   typealias Events = MainSceneEvents

   typealias State2 = ViewState
   typealias State = StackState

   lazy var scenario: Scenario = BalanceScenario(
      works: BalanceWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: BalanceScenarioInputEvents()
   )

   var events: EventsStore = .init()

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

   private lazy var scrollWrapper = ScrollViewModelY()
      .set(.bounce(false))
      .set(.arrangedModels([
         //   selectPeriod, // TODO: - Period select
         //   Spacer(20),
         Spacer(8),
         frameCellStackModel,
         Spacer(27),
         annulationFrame,
         Spacer(8),
         inProgessFrame,
         Grid.xxx.spacer
      ]))

   private lazy var errorBlock = CommonErrorBlock<Design>()
   private lazy var activityIndicator = ActivityIndicator<Design>()

   // MARK: - Services

   private lazy var useCase = Asset.apiUseCase

   private var balance: Balance?

   override func start() {
      axis(.vertical)
      distribution(.fill)
      alignment(.fill)
      arrangedModels([
         scrollWrapper
      ])

      addModel(errorBlock, setup: {
         $0.fitToView($1)
      })
      addModel(activityIndicator, setup: {
         $0.fitToView($1)
      })

      scrollWrapper
         .on(\.didScroll) { [weak self] in
            self?.send(\.didScroll, $0)
         }
         .on(\.willEndDragging) { [weak self] in
            self?.send(\.willEndDragging, $0)
         }
      scrollWrapper.view.alwaysBounceVertical = true

      setState(.initial)
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
      if let date1 = dateFormatter.date(from: distr.expireDate.string) {
         let date2 = Date()
         diffs = Calendar.current.numberOf24DaysBetween(date2, and: date1)
      }

      leftToSendFrame
         .set(.text(String(distr.amount)))
         .set(.caption("\(Text.title.sended): \(distr.sent)"))
         .set(.burn("\(diffs) \(getDeclension(abs(diffs)))"))
   }

   private func getDeclension(_ day: Int) -> String {
      let preLastDigit = day % 100 / 10
      if preLastDigit == 1 {
         return "дней"
      }
      else {
         switch day % 10 {
         case 1:
            return "день"
         case 2, 3, 4:
            return "дня"
         default:
            return "дней"
         }
      }
   }
}

enum BalanceSceneState {
   case initial
   case balanceDidLoad(Balance)
   case loadBalanceError
}

extension BalanceScene: StateMachine {
   func setState(_ state: BalanceSceneState) {
      switch state {
      case .initial:
         scrollWrapper.alpha(0.42)
         errorBlock.hidden(true)
         activityIndicator.hidden(false)
      case .balanceDidLoad(let balance):
         scrollWrapper.alpha(1)
         errorBlock.hidden(true)
         activityIndicator.hidden(true)
         setBalance(balance)
      case .loadBalanceError:
         scrollWrapper.alpha(0.42)
         errorBlock.hidden(false)
         activityIndicator.hidden(true)
      }
   }
}

extension Calendar {
   func numberOf24DaysBetween(_ from: Date, and to: Date) -> Int {
      let numberOfDays = dateComponents([.day], from: from, to: to)

      return numberOfDays.day! + 1
   }
}
