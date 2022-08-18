//
//  BalanceViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import CoreFoundation
import ReactiveWorks
import UIKit

struct BalanceViewEvent: InitProtocol {}

///////// """ STATEABLE -> PARAMETRIC """

final class BalanceViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{
   typealias State = StackState
   var eventsStore: BalanceViewEvent = .init()

   // MARK: - Frame Cells

   private lazy var frameModel = LabelIconHorizontalModel<Design>()
      .set(.backColor(Design.color.frameCellBackground))
      .set(.height(48))
      .set(.text(Text.title.selectPeriod))
      .set(.image(Design.icon.calendarLine))

   private lazy var myAccountFrame = FrameCellModel<Design>()
      .set(.backColor(Design.color.frameCellBackground))
      .set(.header(Text.title.myAccount))

   private lazy var leftToSendFrame = FrameCellModel<Design>()
      .set(.header(Text.title.leftToSend))
      .set(.borderWidth(1))
      .set(.backColor(Design.color.frameCellBackgroundSecondary))
      .set(.borderColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))

   private lazy var frameCellStackModel = WrappedX(
      ScrollViewModelX()
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

//   StackModel()
//      .set_axis(.horizontal)
//      .set_distribution(.fillEqually)
//      .set_alignment(.center)
//      .set_spacing(16)
//      .set_models([
//         myAccountFrame,
//         leftToSendFrame
//      ])

   private lazy var annulationFrame = BalanceStatusFrame<Design>()
      .setMain {
         $0
            .set_image(Design.icon.cross)
            .set_color(Design.color.textError)
      } setRight: {
         $0
            .set_text("Аннулировано")
            .set_color(Design.color.textError)
      } setDown: {
         $0
            .set_text("0")
      }
      .set_backColor(Design.color.errorSecondary)

   private lazy var inProgessFrame = BalanceStatusFrame<Design>()
      .setMain {
         $0
            .set_image(Design.icon.inProgress)
            .set_color(Design.color.success)
      } setRight: {
         $0
            .set_text("На согласовании")
            .set_color(Design.color.success)
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
         frameModel,
         Spacer(20),
         frameCellStackModel,
         Spacer(27),
         annulationFrame,
         Spacer(8),
         inProgessFrame,
         Grid.xxx.spacer,
      ]))

      useCase.retainedWork(\.loadBalance)
         .doAsync()
         .onSuccess { [weak self] balance in
            self?.setBalance(balance)
         }
         .onFail {
            print("balance not loaded")
         }
   }
}

extension BalanceViewModel {
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

///////// """ STATEABLE -> PARAMETRIC """
