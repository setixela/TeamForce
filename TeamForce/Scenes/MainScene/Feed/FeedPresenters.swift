//
//  FeedPresenters.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.09.2022.
//

import ReactiveWorks
import UIKit

final class FeedPresenters<Design: DesignProtocol>: Designable {
   var events: EventsStore = .init()
   var userName: String = ""

   var feedCellPresenter: Presenter<FeedElement, WrappedX<StackModel>> {
      Presenter { [weak self] work in

         guard let self = self else { return }

         let feed = work.unsafeInput.item
         let index = work.unsafeInput.index

         let dateLabel = FeedPresenters.makeInfoDateLabel(feed: feed)

         let messageButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.messageCloud)
               $1.text(String(feed.commentsAmount))
            }

         let likeButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.like)
               $1.text(String(feed.likesAmount))
            }

         likeButton.view.startTapGestureRecognize(cancelTouch: true)

         likeButton.view.on(\.didTap, self) {
            let body = PressLikeRequest.Body(
               likeKind: 1,
               transactionId: feed.transaction?.id,
               challengeId: feed.challenge?.id,
               challengeReportId: feed.winner?.id
            )
            let request = PressLikeRequest(
               token: "",
               body: body,
               index: index
            )
            $0.send(\.reactionPressed, request)

            likeButton.setState(.selected)
         }

         let reactionsBlock = StackModel()
            .axis(.horizontal)
            .alignment(.leading)
            .distribution(.fill)
            .spacing(4)
            .arrangedModels([
               messageButton,
               likeButton,
               Grid.xxx.spacer
            ])

         if feed.transaction != nil {
            guard let transaction = feed.transaction else { return }
            let senderId = transaction.senderId
            let recipientId = transaction.recipientId
            let sender = "@" + transaction.senderTgName.string
            let recipient = "@" + transaction.recipientTgName.string

            let type = FeedTransactType.make(feed: feed, currentUserName: self.userName)

            let infoLabel = FeedPresenters.makeInfoLabel(feed: feed, type: type, eventType: EventType.transaction)

            let icon = self.makeIcon(feed: feed, type: EventType.transaction)

            infoLabel.view.on(\.didSelect) {
               switch $0 {
               case sender:
                  self.send(\.didSelect, senderId ?? -1)
               case recipient:
                  self.send(\.didSelect, recipientId ?? -1)
               default:
                  print("selected error")
               }
            }

            if feed.transaction?.userLiked == true {
               likeButton.setState(.selected)
            }

            let hashTagBlock = HashTagsScrollModel<Design>()
            hashTagBlock.setup(transaction)

            let infoBlock = StackModel()
               .spacing(Grid.x10.value)
               .axis(.vertical)
               .alignment(.fill)
               .arrangedModels([
                  dateLabel,
                  infoLabel,
                  reactionsBlock,
                  hashTagBlock
               ])

            var backColor = Design.color.background
            if type == .youGotAmountFromSome || type == .youGotAmountFromAnonym {
               backColor = Design.color.successSecondary
            }

            let cellStack = WrappedX(
               StackModel()
                  .padding(.outline(Grid.x8.value))
                  .spacing(Grid.x12.value)
                  .axis(.horizontal)
                  .alignment(.top)
                  .arrangedModels([
                     icon,
                     infoBlock
                  ])
                  .backColor(backColor)
                  .cornerRadius(Design.params.cornerRadiusSmall)
            )
            .padding(.verticalOffset(Grid.x16.value))

            work.success(result: cellStack)
         } else if feed.winner != nil {
            let icon = self.makeIcon(feed: feed, type: EventType.winner)
            let infoLabel = FeedPresenters.makeInfoLabel(feed: feed, eventType: EventType.winner)

            let infoBlock = StackModel()
               .spacing(Grid.x10.value)
               .axis(.vertical)
               .alignment(.fill)
               .arrangedModels([
                  dateLabel,
                  infoLabel
               ])

            let cellStack = WrappedX(
               StackModel()
                  .padding(.outline(Grid.x8.value))
                  .spacing(Grid.x12.value)
                  .axis(.horizontal)
                  .alignment(.top)
                  .arrangedModels([
                     icon,
                     infoBlock
                  ])
                  .cornerRadius(Design.params.cornerRadiusSmall)
            )
            .padding(.verticalOffset(Grid.x16.value))

            work.success(result: cellStack)
         } else if feed.challenge != nil {
            let icon = self.makeIcon(feed: feed, type: EventType.challenge)
            let infoLabel = FeedPresenters.makeInfoLabel(feed: feed, eventType: EventType.challenge)

            if feed.challenge?.userLiked == true {
               likeButton.setState(.selected)
            }
            
            let infoBlock = StackModel()
               .spacing(Grid.x10.value)
               .axis(.vertical)
               .alignment(.fill)
               .arrangedModels([
                  dateLabel,
                  infoLabel,
                  reactionsBlock
               ])
            let cellStack = WrappedX(
               StackModel()
                  .padding(.outline(Grid.x8.value))
                  .spacing(Grid.x12.value)
                  .axis(.horizontal)
                  .alignment(.top)
                  .arrangedModels([
                     icon,
                     infoBlock
                  ])
                  .cornerRadius(Design.params.cornerRadiusSmall)
            )
            .padding(.verticalOffset(Grid.x16.value))

            work.success(result: cellStack)
         }
      }
   }
}

extension FeedPresenters {
   static func makeInfoDateLabel(feed: FeedElement) -> LabelModel {
      let dateAgoText = feed.time?.timeAgoConverted
      var eventText = ""
      if let anon = feed.transaction?.isAnonymous {
         eventText = anon ? "" : " • " + "Публичная благодарность"
      }

      let titleText = dateAgoText.string + eventText

      let dateLabel = LabelModel()
         .numberOfLines(0)
         .set(Design.state.label.caption)
         .textColor(Design.color.textSecondary)
         .text(titleText)

      return dateLabel
   }

   static func makeInfoLabel(feed: FeedElement, type: FeedTransactType? = nil, eventType: EventType) -> LabelModel {
      let infoLabel = LabelModel()
         .numberOfLines(0)
         .set(Design.state.label.caption)
         .textColor(Design.color.iconBrand)

      let infoText: NSMutableAttributedString = .init(string: "")

      switch eventType {
      case .transaction:
         let recipientName = "@" + (feed.transaction?.recipientTgName ?? "")
         let senderName = "@" + (feed.transaction?.senderTgName ?? "")
         let amountText = "\(Int(feed.transaction?.amount ?? 0))" + " " + "спасибок"
         guard let type = type else { return infoLabel }
         switch type {
         case .youGotAmountFromSome:
            infoText.append("Вы получили ".colored(Design.color.text))
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" от ".colored(Design.color.text))
            infoText.append(senderName.colored(Design.color.textBrand))
         case .youGotAmountFromAnonym:
            infoText.append("Вы получили ".colored(Design.color.text))
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" от аноним".colored(Design.color.text))
         case .someGotAmountFromSome:
            infoText.append(recipientName.colored(Design.color.textBrand))
            infoText.append(" получил ".colored(Design.color.text))
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" от ".colored(Design.color.text))
            infoText.append(senderName.colored(Design.color.textBrand))
         case .someGotAmountFromAnonym:
            infoText.append(recipientName.colored(Design.color.textBrand))
            infoText.append(" получил ".colored(Design.color.text))
            infoText.append(amountText.colored(Design.color.textSuccess))
            infoText.append(" от аноним".colored(Design.color.text))
         }

         infoLabel.attributedText(infoText)

         infoLabel.view.makePartsClickable(user1: recipientName, user2: senderName)
      case .winner:
         let winnerName = "@" + (feed.winner?.winnerTgName ?? "")
         let challengeName = "«" + (feed.winner?.challengeName ?? "") + "»"
         infoText.append(winnerName.colored(Design.color.textBrand))
         infoText.append(" победил в челлендже ".colored(Design.color.text))
         infoText.append(challengeName.colored(Design.color.textBrand))

         infoLabel.attributedText(infoText)
      case .challenge:
         let challengeName = "«" + (feed.challenge?.name ?? "") + "»"
         let creatorName = "@" + (feed.challenge?.creatorTgName ?? "")
         infoText.append("Создан челлендж ".colored(Design.color.text))
         infoText.append(challengeName.colored(Design.color.textBrand))
         infoText.append(" пользователем ".colored(Design.color.text))
         infoText.append(creatorName.colored(Design.color.textBrand))

         infoLabel.attributedText(infoText)
      }
      return infoLabel
   }

   func makeIcon(feed: FeedElement, type: EventType) -> ImageViewModel {
      let icon = ImageViewModel()
         .contentMode(.scaleAspectFill)
         //.image(Design.icon.newAvatar)
         .cornerRadius(Grid.x36.value / 2)
         .size(.square(Grid.x36.value))
      
      switch type {
      case .transaction:
         if let recipientPhoto = feed.transaction?.recipientPhoto {
            icon.url(TeamForceEndpoints.urlBase + recipientPhoto)
         } else {
            let userIconText =
            String(feed.transaction?.recipientFirstName?.first ?? "?") +
            String(feed.transaction?.recipientSurname?.first ?? "?")
//            icon
//               .textImage(userIconText, Design.color.backgroundBrand)
//               .backColor(Design.color.backgroundBrand)
            // TODO: - сделать через .textImage
            DispatchQueue.global(qos: .background).async {
               let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  icon
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
               }
            }
            
            //icon.image(Design.icon.newAvatar)
         }
      case .winner:
         if let winnerPhoto = feed.winner?.winnerPhoto {
            icon.url(TeamForceEndpoints.urlBase + winnerPhoto)
         } else {
            //icon.image(Design.icon.newAvatar)
            let userIconText =
            String(feed.winner?.winnerFirstName?.first ?? "?") +
            String(feed.winner?.winnerSurname?.first ?? "?")
            // TODO: - сделать через .textImage
            DispatchQueue.global(qos: .background).async {
               let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  icon
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
               }
            }
            
//            icon
//               .textImage(userIconText, Design.color.backgroundBrand)
//               .backColor(Design.color.backgroundBrand)
         }
      case .challenge:
         icon.image(Design.icon.challengeAvatar)
      }

      return icon
   }
}

enum FeedTransactType {
   static func make(feed: FeedElement, currentUserName: String) -> Self {
      if feed.transaction?.recipientTgName == currentUserName {
         if feed.transaction?.isAnonymous ?? false {
            return .youGotAmountFromAnonym
         } else {
            return .youGotAmountFromSome
         }
      }
      if feed.transaction?.isAnonymous ?? false {
         return .someGotAmountFromAnonym
      }
      return .someGotAmountFromSome
   }

   case youGotAmountFromSome
   case youGotAmountFromAnonym

   case someGotAmountFromSome
   case someGotAmountFromAnonym
}

extension FeedPresenters: Eventable {
   struct Events: InitProtocol {
      var didSelect: Int?
      var reactionPressed: PressLikeRequest?
      // var dislikePressed: Int?
   }
}

enum EventType {
   case transaction
   case winner
   case challenge
}
