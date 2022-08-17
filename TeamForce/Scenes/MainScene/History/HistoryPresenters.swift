//
//  HistoryPresenters.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryPresenters<Design: DesignProtocol>: Designable {
   static var transactToIconSubtitle: Presenter<TransactionItem, IconTitleSubtitleModel> {
      Presenter<TransactionItem, IconTitleSubtitleModel> { work in
         let item = work.unsafeInput

         var rightText: String
         var downText: String
         var image: UIImage

         switch item.state {
         case .recieved:
            rightText = "Перевод от " + item.sender.senderTgName
            downText = item.amount
            image = Design.icon.recieveCoinIcon
         default:
            rightText = "Перевод для " + item.recipient.recipientTgName
            downText = "+" + item.amount
            image = Design.icon.sendCoinIcon
         }

         let cell = IconTitleSubtitleModel(isAutoreleaseView: true)
            .set(.image(image))
            .set(.padding(.outline(10)))
            .set(.size(.init(width: 64, height: 64)))
            .setRight {
               $0
                  .set(.text(rightText))
                  .setDown {
                     $0.set(.text(downText))
                  }
            }
         work.success(result: cell)
      }
   }
}

struct TransactionItem {
   enum State {
      case sendSuccess
      case sendDeclined
      case sendInProgress
      case sendCanceled

      case recieved
   }

   let state: State
   let sender: Sender
   let recipient: Recipient
   let amount: String
   let createdAt: String
}
