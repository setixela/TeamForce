//
//  FeedDetailUserInfoBlock.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import Foundation

final class FeedDetailUserInfoBlock<Design: DSP>: StackModel, Designable {
   lazy var filterButtons = FeedDetailFilterButtons<Design>()

   lazy var image = WrappedY(ImageViewModel()
      .image(Design.icon.avatarPlaceholder)
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
         $1.text("0")
      }

   lazy var dislikeButton = ReactionButton<Design>()
      .setAll {
         $0.image(Design.icon.dislike)
         $1.text("0")
      }

   lazy var reactionsBlock = StackModel()
      .axis(.horizontal)
      .alignment(.leading)
      .distribution(.fill)
      .spacing(4)
      .arrangedModels([
         likeButton,
         dislikeButton,
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
         Spacer(16)
      ])
   }
}

extension FeedDetailUserInfoBlock: SetupProtocol {
   func setup(_ data: (Feed, String)) {
      let feed = data.0
      let userName = data.1
      configureImage(feed: feed)
      let dateText = FeedPresenters<Design>.makeInfoDateLabel(feed: feed).view.text
      dateLabel.text(dateText ?? "")
      let type = FeedTransactType.make(feed: feed, currentUserName: userName)
      let infoText = FeedPresenters<Design>.makeInfoLabel(feed: feed, type: type).view.attributedText

      infoLabel.attributedText(infoText!)
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

      likeButton.models.right.text(likeAmount)
      dislikeButton.models.right.text(dislikeAmount)

      if feed.transaction.userLiked == true {
         likeButton.models.main.imageTintColor(Design.color.activeButtonBack)
      }
      if feed.transaction.userDisliked == true {
         dislikeButton.models.main.imageTintColor(Design.color.activeButtonBack)
      }
   }

   private func configureImage(feed: Feed) {
      if let recipientPhoto = feed.transaction.photoUrl {
         image.subModel.url(recipientPhoto)
      } else {
         if let nameFirstLetter = feed.transaction.recipientFirstName?.first,
            let surnameFirstLetter = feed.transaction.recipientSurname?.first
         {
            let text = String(nameFirstLetter) + String(surnameFirstLetter)
            DispatchQueue.global(qos: .background).async {
               let image = text.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async { [weak self] in
                  self?.image.subModel
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
               }
            }
         }
      }
   }
}
