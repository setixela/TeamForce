//
//  TransactionStatusViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 02.08.2022.
//

import ReactiveWorks
import UIKit

struct StatusViewInput {
   var sendCoinInfo: SendCoinRequest
   var username: String
}

struct TransactionStatusViewEvents: InitProtocol {
   var hide: Event<Void>?
   var didHide: Event<Void>?
}

final class TransactionStatusViewModel<Design: DSP>: BaseViewModel<StackViewExtended>,
   Communicable,
   Stateable2,
   Designable
{
   typealias State = StackState
   typealias State2 = ViewState

   var events: TransactionStatusViewEvents = .init()

   private lazy var image: ImageViewModel = .init()
      .set(.size(.init(width: 275, height: 275)))
      .set(.image(Design.icon.transactSuccess))
      .set(.contentMode(.scaleAspectFit))

   private lazy var recipientCell = SendCoinRecipentCell<Design>()
      .setAll { avatar, userName, nickName, amount in
         avatar
            .set_size(.square(44))
            .set_cornerRadius(44/2)
         userName
            .set_text("hello")
         nickName
            .set_text("world")
         amount
      }
      .set_padding(.outline(Grid.x16.value))
      .set_cornerRadius(Design.params.cornerRadius)
      .set_shadow(Design.params.cellShadow)

   let button = Design.button.default
      .set(.title(Design.Text.button.toTheBeginingButton))

   override func start() {
      set(Design.state.stack.default)
      set(.backColor(Design.color.backgroundSecondary))
      set(.cornerRadius(Design.params.cornerRadius))
      set(.alignment(.fill))

      set(.models([
         Spacer(20),
         image,
         Spacer(20),
         recipientCell,
         Spacer(),
         button
      ]))
      .onEvent(\.hide) { [weak self] in
         self?.hide()
      }

      button.onEvent(\.didTap) {
         self.hide()
      }
   }

   private func setup(info: SendCoinRequest, username: String) {

//      amountLabel.set(.text("-" + info.amount))
//      reasonLabel.set(.text(info.reason))
//      recipientLabel.set(.text(TextBuilder.title.recipient + username))
   }
}

extension TransactionStatusViewModel {

   private func hide() {
      print("\nHIDE\n")

      view.removeFromSuperview()

      sendEvent(\.didHide)
   }
}

final class SendCoinRecipentCell<Design: DSP>: Combos<SComboMRDR<ImageViewModel, LabelModel, LabelModel, CurrencyLabelDT<Design>>> {

}
