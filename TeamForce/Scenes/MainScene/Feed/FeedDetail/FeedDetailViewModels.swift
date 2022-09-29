//
//  FeedDetailScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.09.2022.
//

import ReactiveWorks
import UIKit

final class FeedDetailViewModels<Design: DSP>: BaseModel, Designable {
   var events: EventsStore = .init()

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

   lazy var topBlock = StackModel()
      .distribution(.fill)
      .alignment(.center)
      .arrangedModels([
         image,
         Spacer(8),
         dateLabel,
         Spacer(8),
         infoLabel,
         Spacer(16),
         reactionsBlock,
         Spacer(16)
      ])

   private lazy var reasonLabel = SettingsTitleBodyDT<Design>()
      .setAll {
         $0
            .text("Cообщение")
            .set(Design.state.label.body4)
         $1
            .text("-")
            .set(Design.state.label.caption)
      }
      .hidden(true)

   private lazy var transactPhoto = Combos<SComboMD<LabelModel, ImageViewModel>>()
      .setAll {
         $0
            .padBottom(10)
            .set(Design.state.label.body4)
            .text("Фотография")
         $1
            .image(Design.icon.transactSuccess)
            .maxHeight(130)
            .maxWidth(130)
            .contentMode(.scaleAspectFill)
            .cornerRadius(Design.params.cornerRadiusSmall)
      }
      .hidden(true)

   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("ИНФОРМАЦИЯ")
            .set(Design.state.label.captionSecondary),
         reasonLabel,
         // transactPhoto,
         Grid.xxx.spacer
      ])
      .distribution(.fill)
      .alignment(.leading)
      .hidden(true)

   lazy var commentField = TextFieldModel()
      .set(Design.state.textField.default)
      .placeholder(Design.Text.title.comment)
      .placeholderColor(Design.color.textFieldPlaceholder)

//      .set(.badgeLabelStates(Design.state.label.defaultError))
//      .set(.badgeState(.backColor(Design.color.background)))
//      .set(.hideBadge)
//      .set {
//         $0.mainModel.icon.image(Design.icon.user)
//         $0.mainModel.textField
//            .placeholder(Design.Text.title.userName)
//            .placeholderColor(Design.color.textFieldPlaceholder)
//      }

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

      if feed.transaction.userLiked == true {
         likeButton.models.main.imageTintColor(Design.color.activeButtonBack)
      }
      if feed.transaction.userDisliked == true {
         dislikeButton.models.main.imageTintColor(Design.color.activeButtonBack)
      }

      if let reason = feed.transaction.reason {
         reasonLabel.models.down.text(reason)
         reasonLabel.hidden(false)
         infoStack.hidden(false)
      }

//      if let photoLink = feed.transaction.photoUrl {
//         transactPhoto.models.down.url(TeamForceEndpoints.urlBase + photoLink)
//         transactPhoto.hidden(false)
//         infoStack.hidden(false)
//      }
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

   func configureEvents(feed: Feed) {
      let transactionId = feed.transaction.id
      send(\.saveInput, feed)

      likeButton.view.startTapGestureRecognize()
      dislikeButton.view.startTapGestureRecognize()

      likeButton.view.on(\.didTap, self) {
         let request = PressLikeRequest(token: "",
                                        likeKind: 1,
                                        transactionId: transactionId)
         $0.send(\.reactionPressed, request)
      }

      dislikeButton.view.on(\.didTap, self) {
         let request = PressLikeRequest(token: "",
                                        likeKind: 2,
                                        transactionId: transactionId)
         $0.send(\.reactionPressed, request)
      }

      commentField
         .on(\.didBeginEditing, self) { slf, _ in
            slf.infoStack.hidden(true)
            slf.topBlock.hidden(true)
         }
         .on(\.didEndEditing, self) { slf, _ in
            slf.infoStack.hidden(false)
            slf.topBlock.hidden(false)
         }
   }
}

extension FeedDetailViewModels: Eventable {
   struct Events: InitProtocol {
      var reactionPressed: PressLikeRequest?
      var saveInput: Feed?
   }
}
