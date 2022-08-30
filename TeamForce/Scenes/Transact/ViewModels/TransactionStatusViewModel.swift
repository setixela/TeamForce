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
            .set_size(.square(44))
            .set_cornerRadius(44/2)
            .set_contentMode(.scaleAspectFill)
         userName
            .set_text("hello")
         nickName
            .set_text("world")
         amount
            .label
            .set_textColor(Design.color.textError)
            .set_text("100")
      }
      .set_padding(.outline(Grid.x16.value))
      .set_cornerRadius(Design.params.cornerRadius)
      .set_shadow(Design.params.cellShadow)
      .set_borderWidth(1.0)
      .set_borderColor(.black)
      .set_alignment(.center)
      .set_distribution(.equalCentering)

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
      var userIconText: String = ""
      
      if let nameFirstLetter = foundUser.name.first,
         let surnameFirstLetter = foundUser.surname.first {
         userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
      }
      
      recipientCell.setAll { avatar, userName, nickName, amount in
         avatar
            .set_size(.square(44))
            .set_cornerRadius(44/2)
         if let urlSuffix = foundUser.photo, urlSuffix.count != 0 {
            avatar.set_url(TeamForceEndpoints.urlBase + "/media/" + urlSuffix)
         } else {
            print("icon text \(userIconText)")
            let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
            avatar
               .set_backColor(Design.color.backgroundBrand)
               .set_image(image)
         }
         
         userName
            .set_text(foundUser.name + " " + foundUser.surname)
         nickName
            .set_text("@" + foundUser.tgName)
         amount.label
            .set_text("-" + info.amount)
         amount.models.right.set_image(Design.icon.logoCurrencyRed)
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

final class SendCoinRecipentCell<Design: DSP>: Combos<SComboMRDR<ImageViewModel, LabelModel, LabelModel, CurrencyLabelDT<Design>>> {

}
