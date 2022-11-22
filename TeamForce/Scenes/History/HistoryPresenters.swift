//
//  HistoryPresenters.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks
import UIKit

final class HistoryPresenters<Design: DesignProtocol>: Designable {
   var events: EventsStore = .init()

   var transactToHistoryCell: Presenter<TransactionItem, WrappedX<StackModel>> {
      Presenter { [weak self] work in
         guard let self = self else { return }
         
         let item = work.unsafeInput.item
         
         guard let transactClass = item.transactClass?.id else {return }
         
         var userIconText: String = ""
         
//         let icon = ImageViewModel()
//            .contentMode(.scaleAspectFill)
//            //.image(Design.icon.newAvatar)
//            .cornerRadius(Grid.x36.value / 2)
//            .size(.square(Grid.x36.value))
         
         let icon = self.makeIcon(item: item)
         
         let amountText = "+" + item.amount + " cпасибок"
         let senderName = (item.sender.senderFirstName ?? "") + " "  + (item.sender.senderSurname ?? "")
         let recipientName = (item.recipient.recipientFirstName ?? "") + " " +
             (item.recipient.recipientSurname ?? "")
         let challengeName = item.sender.challengeName ?? ""
         
         let infoLabel = LabelModel()
            .numberOfLines(0)
            .set(Design.state.label.caption)
            .textColor(Design.color.iconBrand)

         let infoText: NSMutableAttributedString = .init(string: "")
      
         let nameFirstLetter = String(item.recipient.recipientFirstName?.first ?? "?")
         let surnameFirstLetter = String(item.recipient.recipientSurname?.first ?? "?")
         userIconText = nameFirstLetter + surnameFirstLetter
         
         switch transactClass {
         case "T":
            infoText.append(amountText.colored(Design.color.textSuccess))
            if item.state == .recieved {
               infoText.append(" от ".colored(Design.color.text))
               if item.isAnonymous {
                  infoText.append("аноним".colored(Design.color.text))
                  //icon.image(Design.icon.anonAvatar)
               } else {
                  infoText.append(senderName.colored(Design.color.textBrand))
//                  if let photoUrl = item.sender.senderPhoto {
//                     icon.url(TeamForceEndpoints.urlBase + photoUrl)
//                  } else {
//                     let nameFirstLetter = String(item.sender.senderFirstName?.first ?? "?")
//                     let surnameFirstLetter = String(item.sender.senderSurname?.first ?? "?")
//                     userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
//                     icon
//                        .textImage(userIconText, Design.color.backgroundBrand)
//                        .backColor(Design.color.backgroundBrand)
//                  }
               }
            } else {
               infoText.append(" для ".colored(Design.color.text))
               infoText.append(recipientName.colored(Design.color.textBrand))
//               if let photoUrl = item.recipient.recipientPhoto {
//                  icon.url(TeamForceEndpoints.urlBase + photoUrl)
//               } else {
//                  icon
//                     .textImage(userIconText, Design.color.backgroundBrand)
//                     .backColor(Design.color.backgroundBrand)
//               }
            }
         case "E", "D":
            print(item)
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" пополнение счета от системы".colored(Design.color.text))
         case "H":
            //icon.image(Design.icon.challengeAvatar)
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" для взноса в челлендж ".colored(Design.color.text))
            infoText.append(challengeName.colored(Design.color.textBrand))
         case "W":
            //icon.image(Design.icon.challengeAvatar)
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" награда из челленджа ".colored(Design.color.text))
            infoText.append(challengeName.colored(Design.color.textBrand))
         case "F":
            //icon.image(Design.icon.challengeAvatar)
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" возврат из челленджа ".colored(Design.color.text))
            infoText.append(challengeName.colored(Design.color.textBrand))
         default:
            print(item)
            print("burnt")
         }
         
         infoLabel.attributedText(infoText)
         
         let cancelButton = ImageViewModel()
            .image(Design.icon.cross)
            .imageTintColor(Design.color.textError)
            .set(.tapGesturing)
            .size(.square(25))
            .hidden(true)
            .padding(.init(top: 7, left: 6, bottom: -7, right: -6))
         
//         cancelButton.view.on(\.didTap) { [weak self] in
//            self?.send(\.cancelButtonPressed, item.id ?? 0)
//         }
         
         cancelButton.view.on(\.didTap, self) {
            $0.send(\.presentAlert, item.id ?? 0)
         }
         
         if item.canUserCancel == true {
            cancelButton.hidden(false)
         }
         
         
         let cellStack = WrappedX(
            StackModel()
               .padding(Design.params.cellContentPadding)
               //.padding(.outline(Grid.x8.value))
               .spacing(Grid.x12.value)
               .axis(.horizontal)
               .alignment(.center)
               .arrangedModels([
                  icon,
                  infoLabel,
                  cancelButton
               ])
               .cornerRadius(Design.params.cornerRadiusSmall)
               .backColor(Design.color.background)
               .shadow(Design.params.cellShadow)
         )
         .padding(.verticalOffset(Grid.x6.value))
         work.success(result: cellStack)
      }
   }
}

extension HistoryPresenters {
   func makeIcon(item: TransactionItem) -> ImageViewModel {
      
      let icon = ImageViewModel()
         .contentMode(.scaleAspectFill)
         .cornerRadius(Grid.x36.value / 2)
         .size(.square(Grid.x36.value))

      
      switch item.transactClass?.id {
      case "T":
         if item.isAnonymous == false {
            var userIconText: String = ""
            var nameFirstLetter = String(item.recipient.recipientFirstName?.first ?? "?")
            var surnameFirstLetter = String(item.recipient.recipientSurname?.first ?? "?")
            var photoUrl = item.recipient.recipientPhoto
            
            if item.isSentTransact == false {
               nameFirstLetter = String(item.sender.senderFirstName?.first ?? "?")
               surnameFirstLetter = String(item.sender.senderSurname?.first ?? "?")
               userIconText = nameFirstLetter + surnameFirstLetter
               photoUrl = item.sender.senderPhoto
            }
            
            userIconText = nameFirstLetter + surnameFirstLetter
            
            if let iconPhoto = photoUrl {
               print(iconPhoto)
               icon.url(TeamForceEndpoints.urlBase + iconPhoto, placeHolder: Design.icon.avatarPlaceholder)
            } else {

               // TODO: - сделать через .textImage
               DispatchQueue.global(qos: .background).async {
                  let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
                  DispatchQueue.main.async {
                     icon
                        .backColor(Design.color.backgroundBrand)
                        .image(image)
                  }
               }
            }
         } else {
            icon.image(Design.icon.anonAvatar)
         }
         
      case "E", "D":
         icon.image(Design.icon.avatarPlaceholder)
      case "H", "W", "F":
         icon.image(Design.icon.challengeAvatar)
      default:
         icon.image(Design.icon.avatarPlaceholder)
      }

      return icon
   }
}


extension HistoryPresenters: Eventable {
   struct Events: InitProtocol {
      var presentAlert: Int?
      var cancelButtonPressed: Int?
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
      case recieved
   }

   let state: State
   let sender: Sender
   let recipient: Recipient
   let amount: String
   let createdAt: String
   let photo: String?
   let isAnonymous: Bool
   let id: Int?
   let transactClass: TransactionClass?
   let canUserCancel: Bool?
   let isSentTransact: Bool?
}
//
//
//final class HistoryPresenters<Design: DesignProtocol>: Designable {
//   var events: EventsStore = .init()
//
//   var transactToHistoryCell: Presenter<TransactionItem, HistoryCellModel<Design>> {
//      Presenter { [weak self] work in
//         guard let self = self else { return }
//
//         let item = work.unsafeInput.item
//
//         // print(work.input)
//         var userNameText: String
//         var userIconText: String = ""
//         var statusHidden: Bool
//         var statusText: String
//         var statusColor: UIColor
//         var sumText: String
//         var textColor: UIColor = Design.color.text
//         // var image = ImageViewModel()
//
//         let nameFirstLetter = String(item.recipient.recipientFirstName?.first ?? "?")
//         let surnameFirstLetter = String(item.recipient.recipientSurname?.first ?? "?")
//         userIconText = nameFirstLetter + surnameFirstLetter
//
//         sumText = item.amount
//         switch item.state {
//         case .recieved:
//            userNameText = item.sender.senderTgName.string
//            statusText = ""
//            textColor = Design.color.success
//            //sumText = "+" + item.amount
//            statusColor = .clear
//            statusHidden = true
//            let nameFirstLetter = String(item.sender.senderFirstName?.first ?? "?")
//            let surnameFirstLetter = String(item.sender.senderSurname?.first ?? "?")
//            userIconText = String(nameFirstLetter) + String(surnameFirstLetter)
//
////            image = Design.icon.recieveCoinIcon
//         case .waiting:
//            userNameText = item.recipient.recipientTgName.string
//            statusText = "   Выполняется   "
//            //sumText = "-" + item.amount
//            statusColor = Design.color.iconBrand
//            statusHidden = false
////            image = Design.icon.sendCoinIcon
//         case .approved:
//            userNameText = item.recipient.recipientTgName.string
//            statusText = "   Выполнен   "
//            //sumText = "-" + item.amount
//            statusColor = Design.color.success
//            statusHidden = false
////            image = Design.icon.sendCoinIcon
//         case .cancelled:
//            userNameText = item.recipient.recipientTgName.string
//            statusText = "   Отменен   "
//            //sumText = "-" + item.amount
//            statusColor = Design.color.textSecondary
//            statusHidden = false
////            image = Design.icon.sendCoinIcon
//         case .declined:
//            userNameText = item.recipient.recipientTgName.string
//            statusText = "   Отклонен   "
//            //sumText = "-" + item.amount
//            statusColor = Design.color.textError
//            statusHidden = false
////            image = Design.icon.sendCoinIcon
//         default:
//            userNameText = item.recipient.recipientTgName.string
//            statusText = "   Выполнен   "
//            //sumText = "-" + item.amount
//            statusColor = Design.color.success
//            statusHidden = false
////            image = Design.icon.sendCoinIcon
//         }
//
//         let cell = HistoryCellModel<Design>()
//            .setAll { icon, userAndStatus, sumLabelAndCancelButton in
//               if !item.isAnonymous || (item.isAnonymous && item.state != .recieved) {
//                  if let urlSuffix = item.photo {
//                     icon.url(TeamForceEndpoints.urlBase + urlSuffix)
//                  } else {
//                     icon
//                        .textImage(userIconText, Design.color.backgroundBrand)
//                        .backColor(Design.color.backgroundBrand)
//                  }
//               }
//
//               userAndStatus
//                  .setAll { userLabel, statusLabel in
//                     userLabel
//                        .text(userNameText)
//
//                     guard statusHidden == false else {
//                        statusLabel.hidden(true)
//                        return
//                     }
//
//                     statusLabel
//                        .text(statusText)
//                        .backColor(statusColor)
//                        .hidden(false)
//                  }
//
//               sumLabelAndCancelButton
//                  .setAll { sumLabel, cancelButton in
//                     sumLabel
//                        .text(sumText)
//                        .textColor(textColor)
//
//                     guard item.state == .waiting else {
//                        cancelButton.hidden(true)
//                        return
//                     }
//
//                     cancelButton
//                        .image(Design.icon.cross)
//                        .imageTintColor(Design.color.textError)
//                        .hidden(false)
//                  }
//
//            }
//
//         cell.on(\.cancelButtonPressed, self) {
//            $0.send(\.cancelButtonPressed, item.id ?? 0)
//         }
//
//         work.success(result: cell)
//      }
//   }
//}
//
//extension HistoryPresenters: Eventable {
//   struct Events: InitProtocol {
//      var cancelButtonPressed: Int?
//   }
//}
//
//struct TransactionItem {
//   enum State {
//      case waiting
//      case approved
//      case declined
//      case ingrace
//      case ready
//      case cancelled
//
////      case sendSuccess
////      case sendDeclined
////      case sendInProgress
////      case sendCanceled
//
//      case recieved
//   }
//
//   let state: State
//   let sender: Sender
//   let recipient: Recipient
//   let amount: String
//   let createdAt: String
//   let photo: String?
//   let isAnonymous: Bool
//   let id: Int?
//}
