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
      Presenter { work in

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

   static var transactToHistoryCell: Presenter<TransactionItem, HistoryCellModel<Design>> {
      Presenter { work in
         let item = work.unsafeInput

         var userName: String
         var statusHidden: Bool
         var statusText: String
         var statusColor: UIColor
         var sumText: String
         var image: UIImage

         switch item.state {
         case .recieved:
            userName = item.sender.senderTgName
            statusText = ""
            sumText = "+" + item.amount
            statusColor = .clear
            statusHidden = true
            image = Design.icon.recieveCoinIcon
         default:
            userName = item.recipient.recipientTgName
            statusText = "   Выполнен   "
            sumText = "-" + item.amount
            statusColor = Design.color.success
            statusHidden = false
            image = Design.icon.sendCoinIcon
         }

         let cell = HistoryCellModel<Design>()
            .setMain { _ in

            } setRight: {
               $0
                  .setMain { model in
                     model
                        .set_text(userName)
                  } setDown: { model in
                     guard statusHidden == false else {
                        model.set_hidden(true)
                        return
                     }

                     model
                        .set_text(statusText)
                        .set_backColor(statusColor)
                        .set_hidden(false)
                  }

            } setRight2: {
               $0
                  .setMain { model in
                     model
                        .set_text(sumText + "   ")
                  } setDown: { model in
                     guard item.state != .recieved else {
                        model.set_hidden(true)
                        return
                     }

                     model
                        .set_image(Design.icon.cross)
                        .set_imageTintColor(Design.color.textError)
                        .set_hidden(false)
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
