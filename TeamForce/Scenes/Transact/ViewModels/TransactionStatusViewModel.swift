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
            .size(.square(44))
            .cornerRadius(44 / 2)
            .contentMode(.scaleAspectFill)
         userName
            .set(Design.state.label.body4)
            .alignment(.left)
         nickName
            .set(Design.state.label.captionSecondary)
            .alignment(.left)
         amount.label
            .height(Grid.x32.value)
            .set(Design.state.label.headline4)
            .textColor(Design.color.textError)
         amount.currencyLogo
            .width(22)
      }
      .padding(.outline(Grid.x16.value))
      .backColor(Design.color.background)
      .cornerRadius(Design.params.cornerRadius)
      .shadow(Design.params.cellShadow)
      .borderColor(.black)
      .alignment(.center)
      .distribution(.equalSpacing)

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
      print("\nHIDE\n")

      view.removeFromSuperview()

      sendEvent(\.didHide)
   }
}

final class SendCoinRecipentCell<Design: DSP>: Combos<SComboMRDR<ImageViewModel, LabelModel, LabelModel, CurrencyLabelDT<Design>>> {}
