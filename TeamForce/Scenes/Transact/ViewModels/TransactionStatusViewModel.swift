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
   var foundUser: FoundUser
}

struct TransactionStatusViewEvents: InitProtocol {
   var hide: Event<Void>?
   var finished: Event<Void>?
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
      .size(.init(width: 275, height: 275))
      .image(Design.icon.transactSuccess)
      .contentMode(.scaleAspectFit)

   private lazy var recipientCell = Design.model.transact.recipientCell

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

      button.on(\.didTap) {
         self.hide()
      }
   }

   func setup(info: SendCoinRequest, username: String, foundUser: FoundUser) {
      var userIconText = ""

      if let nameFirstLetter = foundUser.name.string.first,
         let surnameFirstLetter = foundUser.surname.string.first
      {
         userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
      }

      recipientCell.setAll { avatar, userName, nickName, amount in

         if let urlSuffix = foundUser.photo, urlSuffix.count != 0 {
            avatar.url(TeamForceEndpoints.urlMediaBase + urlSuffix)
         } else {
            print("icon text \(userIconText)")
            let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
            avatar
               .backColor(Design.color.backgroundBrand)
               .image(image)
         }

         userName
            .text(foundUser.name.string + " " + foundUser.surname.string)
         nickName
            .text("@" + foundUser.tgName.string)
         amount.label
            .text("-" + info.amount)
         amount.models.right
            .image(Design.icon.logoCurrencyRed)
            .imageTintColor(Design.color.iconError)
      }
   }
}

extension TransactionStatusViewModel {
   private func hide() {
      sendEvent(\.finished)
   }
}
