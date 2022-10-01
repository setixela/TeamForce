//
//  FeedPresenters.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 20.09.2022.
//

import ReactiveWorks
import UIKit

class FeedPresenters<Design: DesignProtocol>: Designable {
   var events: EventsStore = .init()
   var userName: String = ""
   private lazy var retainer = Retainer()

   var feedCellPresenter: Presenter<Feed, WrappedX<StackModel>> {
      Presenter { [weak self] work in

         guard let self = self else { return }

         let feed = work.unsafeInput

         let senderId = feed.transaction.senderId
         let recipientId = feed.transaction.recipientId
         let sender = "@" + feed.transaction.sender
         let recipient = "@" + feed.transaction.recipient
         let transactionId = feed.transaction.id

//         let isPersonal = feed.eventType.isPersonal
//         let hasScope = feed.eventType.hasScope
//         let isAnonTransact = feed.transaction.isAnonymous

         let type = FeedTransactType.make(feed: feed, currentUserName: self.userName)

         let dateLabel = FeedPresenters.makeInfoDateLabel(feed: feed)
         let infoLabel = FeedPresenters.makeInfoLabel(feed: feed, type: type)
         let icon = self.makeIcon(feed: feed)

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

//         let tagBlock = StackModel()
//            .axis(.horizontal)
//            .spacing(4)
         var commentsAmount = "0"
         commentsAmount = String(feed.transaction.commentsAmount ?? 0)

         let messageButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.messageCloud)
               $1.text(commentsAmount)
            }
         var likeAmount = "0"
         var dislikeAmount = "0"

         if let reactions = feed.transaction.reactions {
            for reaction in reactions {
               if reaction.code == "like" {
                  likeAmount = String(reaction.counter ?? 0)
               } else if reaction.code == "dislike" {
                  dislikeAmount = String(reaction.counter ?? 0)
               }
            }
         }

         let likeButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.like)
               $1.text(likeAmount)
            }

         let dislikeButton = ReactionButton<Design>()
            .setAll {
               $0.image(Design.icon.dislike)
               $1.text(dislikeAmount)
            }

         if feed.transaction.userLiked == true {
            likeButton.setState(.selected)
         }
         if feed.transaction.userDisliked == true {
            dislikeButton.setState(.selected)
         }

         likeButton.view.startTapGestureRecognize(cancelTouch: true)
         dislikeButton.view.startTapGestureRecognize(cancelTouch: true)

         likeButton.view.on(\.didTap, self) {
            let request = PressLikeRequest(token: "",
                                           likeKind: 1,
                                           transactionId: transactionId)
            $0.send(\.reactionPressed, request)

            likeButton.setState(.selected)
            dislikeButton.setState(.none)
         }

         dislikeButton.view.on(\.didTap, self) {
            let request = PressLikeRequest(token: "",
                                           likeKind: 2,
                                           transactionId: transactionId)
            $0.send(\.reactionPressed, request)
            dislikeButton.setState(.selected)
            likeButton.setState(.none)
         }

         let reactionsBlock = StackModel()
            .axis(.horizontal)
            .alignment(.leading)
            .distribution(.fill)
            .spacing(4)
            .arrangedModels([
               messageButton,
               likeButton,
               dislikeButton,
               Grid.xxx.spacer
            ])

         let tags = (feed.transaction.tags ?? []).map { tag in
            WrappedX(
               LabelModel()
                  .set(Design.state.label.caption2)
                  .text("# " + tag.name)
            )
            .backColor(Design.color.infoSecondary)
            .cornerRadius(Design.params.cornerRadiusMini)
            .padding(.outline(8))
         }

         let hashTagBlock = ScrollViewModelX()
            .set(.spacing(4))
            .set(.arrangedModels(tags))
            .set(.hideHorizontalScrollIndicator)

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

         self.retainer.retain(work)
         work.success(result: cellStack)
      }
   }
}

extension FeedPresenters {
   static func makeInfoDateLabel(feed: Feed) -> LabelModel {
      let dateAgoText = feed.time.timeAgoConverted
      let eventText = feed.transaction.isAnonymous ? "" : " • " + "Публичная благодарность"
      let titleText = dateAgoText + eventText

      let dateLabel = LabelModel()
         .numberOfLines(0)
         .set(Design.state.label.caption)
         .textColor(Design.color.textSecondary)
         .text(titleText)

      return dateLabel
   }

   static func makeInfoLabel(feed: Feed, type: FeedTransactType) -> LabelModel {
      let recipientName = "@" + feed.transaction.recipient
      let senderName = "@" + feed.transaction.sender
      let amountText = "\(Int(feed.transaction.amount))" + " " + "спасибок"
      let infoText: NSMutableAttributedString = .init(string: "")

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

      let infoLabel = LabelModel()
         .numberOfLines(0)
         .set(Design.state.label.caption)
         .textColor(Design.color.iconBrand)
         .attributedText(infoText)

      infoLabel.view.makePartsClickable(user1: recipientName, user2: senderName)

      return infoLabel
   }

   func makeIcon(feed: Feed) -> ImageViewModel {
      let icon = ImageViewModel()
         .contentMode(.scaleAspectFill)
         .image(Design.icon.avatarPlaceholder)
         .size(.square(Grid.x36.value))
         .cornerRadius(Grid.x36.value / 2)
      if let recipientPhoto = feed.transaction.photoUrl {
         icon.url(recipientPhoto)
      } else {
         if let nameFirstLetter = feed.transaction.recipientFirstName?.first,
            let surnameFirstLetter = feed.transaction.recipientSurname?.first
         {
            let text = String(nameFirstLetter) + String(surnameFirstLetter)
            DispatchQueue.global(qos: .background).async {
               let image = text.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  icon
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
               }
            }
         }
      }

      return icon
   }
}

enum FeedTransactType {
   static func make(feed: Feed, currentUserName: String) -> Self {
      if feed.transaction.recipient == currentUserName {
         if feed.transaction.isAnonymous {
            return .youGotAmountFromAnonym
         } else {
            return .youGotAmountFromSome
         }
      }
      if feed.transaction.isAnonymous {
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
