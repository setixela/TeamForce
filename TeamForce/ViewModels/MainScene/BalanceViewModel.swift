//
//  BalanceViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import RealmSwift
import UIKit

struct BalanceViewEvent: InitProtocol {}

final class BalanceViewModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
   Communicable,
   Stateable,
   Assetable
{

   var eventsStore: BalanceViewEvent = .init()

   // MARK: - Frame Cells

   private lazy var digitalThanksTitle = Design.label.headline4
      .set(.text(Text.title.make(\.digitalThanks)))
      .set(.numberOfLines(1))
      .set(.alignment(.left))
      .set(.padding(.init(top: 22, left: 0, bottom: 26, right: 0)))

   private lazy var frameModel = LabelIconHorizontalModel<Design>()
      .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
      .set(.height(48))
      .set(.text(Text.title.make(\.selectPeriod)))
      .set(.image(Design.icon.make(\.calendarLine)))

   private lazy var frameModel2 = DoubleLabelPairModel<Design>()
      .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
      .set(.height(48))

   private lazy var myAccountFrame = FrameCellModel<Design>()
      .set(.backColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))
      .set(.header(Text.title.make(\.myAccount)))

   private lazy var leftToSendFrame = FrameCellModel<Design>()
      .set(.header(Text.title.make(\.leftToSend)))
      .set(.borderWidth(1))
      .set(.borderColor(.init(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.08)))

   private lazy var frameCellStackModel = StackModel()
      .set(.axis(.horizontal))
      .set(.distribution(.fillEqually))
      .set(.alignment(.center))
      .set(.spacing(8))
      .set(.models([
         myAccountFrame,
         leftToSendFrame
      ]))

   private lazy var menuButton = BarButtonModel()
      .sendEvent(\.initWithImage, Design.icon.make(\.sideMenu))

   // MARK: - Services

   private lazy var userProfileApiModel = GetProfileApiModel(apiEngine: Asset.service.apiEngine)
   private lazy var balanceApiModel = GetBalanceApiModel(apiEngine: Asset.service.apiEngine)
   private lazy var safeStringStorage = StringStorageModel(engine: Asset.service.safeStringStorage)

   private var balance: Balance?

   override func start() {
      set(.axis(.vertical))
      set(.distribution(.fill))
      set(.alignment(.fill))
      set(.models([
         digitalThanksTitle,
         frameModel,
         Spacer(size: 20),
         frameCellStackModel,
         Spacer(size: 8),
         frameModel2,
         Spacer()
      ]))

      weak var weakSelf = self

      safeStringStorage
         .onEvent(\.responseValue) { token in
            weakSelf?.balanceApiModel
               .onEvent(\.success) { balance in
                  weakSelf?.setBalance(balance)
               }
               .onEvent(\.error) {
                  print($0)
               }
               .sendEvent(\.request, TokenRequest(token: token))
         }
         .onEvent(\.error) {
            print($0)
         }
         .sendEvent(\.requestValueForKey, "token")
   }
}

extension BalanceViewModel {
   private func setBalance(_ balance: Balance) {
      setIncome(balance.income)
      setDistr(balance.distr)

      let frozenSum = balance.income.frozen + balance.distr.frozen
      let cancelledSum = balance.income.cancelled + balance.distr.cancelled

      frameModel2
         .set(.leftPair(text1: "\(Text.title.make(\.onAgreement)): ",
                        text2: "\(frozenSum)"))
         .set(.rightPair(text1: "\(Text.title.make(\.canceled)): ",
                         text2: "\(cancelledSum)"))
   }

   private func setIncome(_ income: Income) {
      myAccountFrame
         .set(.text(String(income.amount)))
         .set(.caption("\(Text.title.make(\.sended)): \(income.sent)"))
   }

   private func setDistr(_ distr: Distr) {
      leftToSendFrame
         .set(.text(String(distr.amount)))
         .set(.caption("\(Text.title.make(\.sended)): \(distr.sent)"))
   }
}
