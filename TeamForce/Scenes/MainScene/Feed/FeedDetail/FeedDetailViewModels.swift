//
//  FeedDetailScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//


import ReactiveWorks
import UIKit

final class FeedDetailViewModels<Design: DSP>: BaseModel, Designable {
   
   lazy var presenter = CommentPresenters<Design>()
   
   lazy var commentTableModel = TableItemsModel<Design>()
      // .backColor(.lightGray)//Design.color.background)
      .backColor(Design.color.background)
      .set(.presenters([
         presenter.commentCellPresenter,
         SpacerPresenter.presenter
      ]))
   
   lazy var filterButtons = FeedDetailFilterButtons<Design>()
   
   
   private lazy var image = WrappedY(ImageViewModel()
      .image(Design.icon.avatarPlaceholder)
      .contentMode(.scaleAspectFill)
      .cornerRadius(70 / 2)
      .size(.square(70))
      .shadow(Design.params.cellShadow)
   )
   
   private lazy var dateLabel = LabelModel()
      .numberOfLines(0)
      .set(Design.state.label.caption)
      .textColor(Design.color.textSecondary)
      
   private lazy var infoLabel = LabelModel()
      .numberOfLines(0)
      .set(Design.state.label.caption)
      .textColor(Design.color.iconBrand)
   
   private lazy var likeButton = ReactionButton<Design>()
      .setAll {
         $0.image(Design.icon.like)
         $1.text("0")
      }
   
   private lazy var dislikeButton = ReactionButton<Design>()
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
   
   lazy var topBlock = StackModel()
      .distribution(.fill)
      .alignment(.center)
      .arrangedModels([
         Spacer(32),
         image,
         Spacer(8),
         dateLabel,
         Spacer(8),
         infoLabel,
         Spacer(16),
         reactionsBlock,
         Spacer(16)
      ])
   
   override func start() {
      filterButtons.buttonComments.setMode(\.selected)
   }
   
   func configureLabels(input: (Feed, String)) {
      let feed = input.0
      let userName = input.1
      
      configureImage(feed: feed)
      let dateText = FeedPresenters<Design>.makeInfoDateLabel(feed: feed).view.text
      dateLabel.text(dateText ?? "")
      let type = FeedTransactType.make(feed: feed, currentUserName: userName)
      let infoText = FeedPresenters<Design>.makeInfoLabel(feed: feed, type: type).view.attributedText
     
      infoLabel
         .attributedText(infoText!)
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
               DispatchQueue.main.async {
                  self.image.subModel
                     .backColor(Design.color.backgroundBrand)
                     .image(image)
               }
            }
         }
      }
   }
}
