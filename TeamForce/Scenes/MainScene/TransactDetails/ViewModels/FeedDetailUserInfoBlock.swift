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
   func setup(_ data: (feedElement: FeedElement, currentUserName: String)) {
      let feed = data.feedElement
      let userName = data.currentUserName
      configureImage(feed: feed)
      configureEvents(feed: feed)
      let dateText = FeedPresenters<Design>.makeInfoDateLabel(feed: feed).view.text
      dateLabel.text(dateText ?? "")
      let type = FeedTransactType.make(feed: feed, currentUserName: userName)
      let infoText = FeedPresenters<Design>.makeInfoLabel(feed: feed, type: type, eventType: EventType.transaction).view.attributedText

      infoLabel.attributedText(infoText!)

      let likeAmount = String(feed.likesAmount)

      likeButton.models.right.text(likeAmount)

      if feed.transaction?.userLiked == true {
         likeButton.setState(.selected)
      }
   }
}

private extension FeedDetailUserInfoBlock {
   func configureImage(feed: FeedElement) {
      if let recipientPhoto = feed.transaction?.recipientPhoto {
         image.subModel.url(TeamForceEndpoints.urlBase + recipientPhoto)
      } else {
         // TODO: - сделать через .textImage
         let userIconText =
         String(feed.transaction?.recipientFirstName?.first ?? "?") +
         String(feed.transaction?.recipientSurname?.first ?? "?")
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

   func configureEvents(feed: FeedElement) {
      likeButton.view.startTapGestureRecognize()
      likeButton.view.on(\.didTap, self) {
         $0.send(\.reactionPressed)
      }

      guard
         let userId = feed.transaction?.recipientId ?? feed.challenge?.creatorId ?? feed.winner?.winnerId
      else {
         return
      }

      image.view.startTapGestureRecognize()
      image.view.on(\.didTap, self) {
         $0.send(\.userAvatarPressed, userId)
      }
   }
}
