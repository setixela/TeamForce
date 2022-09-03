//
//  TransactSendErrorViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 03.09.2022.
//

import ReactiveWorks
import UIKit

struct SystemErrorBlockEvents: InitProtocol {
   var didClosed: Void?
}

final class SystemErrorBlockVM<Design: DSP>: BaseViewModel<StackViewExtended>,
   Eventable,
   Stateable2,
   Designable
{
   typealias State = StackState
   typealias State2 = ViewState

   typealias Events = SystemErrorBlockEvents

   var events = [Int: LambdaProtocol?]()

   private lazy var errorBlock = Design.model.common.connectionErrorBlock

   let button = Design.button.default
      .set(.title(Design.Text.button.closeButton))

   override func start() {
      set(Design.state.stack.default)
      set(.backColor(Design.color.backgroundSecondary))
      set(.cornerRadius(Design.params.cornerRadius))
      set(.alignment(.fill))

      set(.models([
         Spacer(20),
         errorBlock,
         Spacer(),
         button
      ]))

      button.onEvent(\.didTap) { [weak self] in
         self?.send(\.didClosed)
      }
   }
}
