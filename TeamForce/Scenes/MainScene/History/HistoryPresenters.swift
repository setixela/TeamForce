//
//  HistoryPresenters.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

struct HistoryPresenters<Design: DesignProtocol>: Designable {
   static var transactToHistoryCell: Presenter<TransactionItem, HistoryCellModel<Design>> {
      Presenter { work in
         let item = work.unsafeInput
         //print(work.input)
         var userNameText: String
         var userIconText: String = ""
         var statusHidden: Bool
         var statusText: String
         var statusColor: UIColor
         var sumText: String
         //var image = ImageViewModel()
         
         if let nameFirstLetter = item.recipient.recipientFirstName?.first,
            let surnameFirstLetter = item.recipient.recipientSurname?.first {
            userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
         }

         switch item.state {
         case .recieved:
            userNameText = item.sender.senderTgName.string
            statusText = ""
            sumText = "+" + item.amount
            statusColor = .clear
            statusHidden = true
            if let nameFirstLetter = item.sender.senderFirstName?.first,
               let surnameFirstLetter = item.sender.senderSurname?.first {
               userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
            }
//            image = Design.icon.recieveCoinIcon
         case .waiting:
            userNameText = item.recipient.recipientTgName.string
            statusText = "   Выполняется   "
            sumText = "-" + item.amount
            statusColor = Design.color.iconBrand
            statusHidden = false
//            image = Design.icon.sendCoinIcon
         case .approved:
            userNameText = item.recipient.recipientTgName.string
            statusText = "   Выполнен   "
            sumText = "-" + item.amount
            statusColor = Design.color.success
            statusHidden = false
//            image = Design.icon.sendCoinIcon
         case .cancelled:
            userNameText = item.recipient.recipientTgName.string
            statusText = "   Отменен   "
            sumText = "-" + item.amount
            statusColor = Design.color.textSecondary
            statusHidden = false
//            image = Design.icon.sendCoinIcon
         case .declined:
            userNameText = item.recipient.recipientTgName.string
            statusText = "   Отклонен   "
            sumText = "-" + item.amount
            statusColor = Design.color.textError
            statusHidden = false
//            image = Design.icon.sendCoinIcon
         default:
            userNameText = item.recipient.recipientTgName.string
            statusText = "   Выполнен   "
            sumText = "-" + item.amount
            statusColor = Design.color.success
            statusHidden = false
//            image = Design.icon.sendCoinIcon
         }

         let cell = HistoryCellModel<Design>()
            .setAll { icon, userAndStatus, sumLabelAndCancelButton in
               if !item.isAnonymous || (item.isAnonymous && item.state != .recieved) {
                  if let urlSuffix = item.photo {
                     icon.url(TeamForceEndpoints.urlBase + urlSuffix)
                  } else {
                     let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
                     icon
                        .backColor(Design.color.backgroundBrand)
                        .image(image)
                  }
               }

               userAndStatus
                  .padLeft(18)
                  .alignment(.leading)
                  .setAll { userLabel, statusLabel in
                     userLabel
                        .text(userNameText)

                     guard statusHidden == false else {
                        statusLabel.hidden(true)
                        return
                     }

                     statusLabel
                        .text(statusText)
                        .backColor(statusColor)
                        .hidden(false)
                  }

               sumLabelAndCancelButton
                  .alignment(.trailing)
                  .setAll { sumLabel, cancelButton in
                     sumLabel
                        .text(sumText)

                     guard item.state != .recieved else {
                        cancelButton.hidden(true)
                        return
                     }

                     cancelButton
                        .image(Design.icon.cross)
                        .imageTintColor(Design.color.textError)
                        .hidden(false)
                  }
            }

         work.success(result: cell)
      }
   }
}

struct TransactionItem {
   enum State {
      case waiting
      case approved
      case declined
      case ingrace
      case ready
      case cancelled
      
//      case sendSuccess
//      case sendDeclined
//      case sendInProgress
//      case sendCanceled

      case recieved
   }

   let state: State
   let sender: Sender
   let recipient: Recipient
   let amount: String
   let createdAt: String
   let photo: String?
   let isAnonymous: Bool
}
