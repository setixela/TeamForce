//
//  FeedDetailUserInfoBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import Foundation
import ReactiveWorks

extension FeedDetailUserInfoBlock: Eventable {
   struct Events: InitProtocol {
      var reactionPressed: Void?
      var userAvatarPressed: Int?
   }
}

final class FeedDetailUserInfoBlock<Design: DSP>: StackModel, Designable {
   var events: EventsStore = .init()

   lazy var image = WrappedY(ImageViewModel()
      .image(Design.icon.newAvatar)
      .contentMode(.scaleAspectFill)
      .cornerRadius(70 / 2)
      .size(.square(70))
      .shadow(Design.params.cellShadow)
   )

   lazy var dateLabel = LabelModel()
      .numberOfLines(0)
      .set(Design.state.label.caption)
      .textColor(Design.color.textSecondary)

   lazy var infoLabel = LabelModel()
      .numberOfLines(0)
      .set(Design.state.label.caption)
      .textColor(Design.color.iconBrand)

   lazy var likeButton = ReactionButton<Design>()
      .setAll {
         $0.image(Design.icon.like)
         $1
            .font(Design.font.caption)
            .text("0")
      }
      .removeAllConstraints()
      .padding(.horizontalOffset(44))
      .width(121)
      .height(42)

   lazy var reactionsBlock = StackModel()
      .axis(.horizontal)
      .alignment(.leading)
      .distribution(.fill)
      .spacing(8)
      .arrangedModels([
         likeButton,
         Grid.xxx.spacer
      ])

   override func start() {
      super.start()

      alignment(.center)
      arrangedModels([
         image,
         Spacer(8),
         dateLabel,
         Spacer(8),
         infoLabel,
         Spacer(16),
         reactionsBlock,
         Spacer(32)
      ])
   }
}

extension FeedDetailUserInfoBlock: SetupProtocol {
   func makeInfoLabel(transaction: EventTransaction, type: FeedTransactType) -> LabelModel {
      let infoLabel = LabelModel()
         .numberOfLines(0)
         .set(Design.state.label.caption)
         .textColor(Design.color.iconBrand)

      let infoText: NSMutableAttributedString = .init(string: "")

      let recipientName = "@" + (transaction.recipientTgName ?? "")
      let senderName = "@" + (transaction.senderTgName ?? "")
      let amountText = "\(Int(transaction.amount))" + " " + "спасибок"
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

      infoLabel.attributedText(infoText)

      return infoLabel
   }

   func setup(_ data: (transaction: EventTransaction, currentUserName: String)) {
      let transaction = data.transaction
      let userName = data.currentUserName
      configureImage(transaction: transaction)
      configureEvents(transaction: transaction)
      let dateText = FeedPresenters<Design>.makeInfoDateLabelForTransaction(transaction: transaction).view.text
      dateLabel.text(dateText ?? "--:--")
      let type = FeedTransactType.makeForTransaction(
         transaction: transaction,
         currentUserName: userName
      )
//      let infoText = FeedPresenters<Design>.makeInfoLabel(feed: feed, type: type, eventType: EventType.transaction).view.attributedText
//
//            infoLabel.attributedText(infoText!)
      let infoText = makeInfoLabel(transaction: transaction, type: type).view.attributedText
      infoLabel.attributedText(infoText!)
      let likeAmount = String(transaction.likeAmount ?? 0)

      likeButton.models.right.text(likeAmount)

      if transaction.userLiked == true {
         likeButton.setState(.selected)
      }
   }
}

private extension FeedDetailUserInfoBlock {
   func configureImage(transaction: EventTransaction) {
      if let recipientPhoto = transaction.recipientPhoto {
         image.subModel.url(TeamForceEndpoints.urlBase + recipientPhoto)
      } else {
         // TODO: - сделать через .textImage
         let userIconText =
            String(transaction.recipientFirstName?.first ?? "?") +
            String(transaction.recipientSurname?.first ?? "?")
         DispatchQueue.global(qos: .background).async {
            let image = userIconText.drawImage(backColor: Design.color.backgroundBrand)
            DispatchQueue.main.async { [weak self] in
               self?.image.subModel
                  .backColor(Design.color.backgroundBrand)
                  .image(image)
            }
         }
      }
   }

   func configureEvents(transaction: EventTransaction) {
      likeButton.view.startTapGestureRecognize()
      likeButton.view.on(\.didTap, self) {
         $0.send(\.reactionPressed)
      }

      guard
         // let userId = feed.transaction?.recipientId ?? feed.challenge?.creatorId ?? feed.winner?.winnerId
         let userId = transaction.recipientId
      else {
         return
      }

      image.view.startTapGestureRecognize()
      image.view.on(\.didTap, self) {
         $0.send(\.userAvatarPressed, userId)
      }
   }
}
