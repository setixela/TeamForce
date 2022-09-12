//
//  FeedViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks
import UIKit

final class FeedViewModels<Design: DSP>: BaseModel, Designable, Stateable {
   enum State {
      case userName(String)
   }

   lazy var filterButtons = FeedFilterButtons<Design>()

   lazy var feedTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .set(.presenters([
         feedCellPresenter,
         SpacerPresenter.presenter
      ]))

   private var userName = ""

   override func start() {
      filterButtons.buttonAll.setMode(\.selected)
   }

   func applyState(_ state: State) {
      switch state {
      case .userName(let value):
         userName = value
      }
   }

   private lazy var feedCellPresenter: Presenter<Feed, WrappedX<StackModel>> = .init { [weak self] work in

      guard let self = self else { return }

      let feed = work.unsafeInput

      let isPersonal = feed.eventType.isPersonal
      let hasScope = feed.eventType.hasScope
      let isAnonTransact = feed.transaction.isAnonymous

      let type = FeedTransactType.make(feed: feed, currentUserName: self.userName)

      let dateLabel = self.makeInfoDateLabel(feed: feed)
      let infoLabel = self.makeInfoLabel(feed: feed, type: type)
      let icon = self.makeIcon(feed: feed)

      let tagBlock = StackModel()
         .axis(.horizontal)
         .spacing(4)

      let messageButton = ReactionButton<Design>()
         .setAll {
            $0.image(Design.icon.messageCloud)
            $1.text("0")
         }

      let likeButton = ReactionButton<Design>()
         .setAll {
            $0.image(Design.icon.like)
            $1.text("0")
         }

      let dislikeButton = ReactionButton<Design>()
         .setAll {
            $0.image(Design.icon.dislike)
            $1.text("0")
         }

      let reactionsBlock = StackModel()
         .axis(.horizontal)
         .alignment(.leading)
         .distribution(.equalSpacing)
         .spacing(4)
         .arrangedModels([
            messageButton,
            likeButton,
            dislikeButton
         ])

//      let hashTagBlock = StackModel()
//         .axis(.horizontal)
//         .alignment(.leading)
//         .distribution(.equalSpacing)
//         .spacing(4)
//         .arrangedModels(
//            (0 ..< Int.random(in: 0 ..< 5)).map { _ -> UIViewModel in
//               self.randomButton
//            }
//         )

      let infoBlock = StackModel()
         .spacing(Grid.x10.value)
         .axis(.vertical)
         .alignment(.leading)
         .arrangedModels([
            dateLabel,
            infoLabel,
            reactionsBlock
            //  hashTagBlock
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
      cellStack.isAutoreleaseView = true

      work.success(result: cellStack)
   }
}

private enum FeedTransactType {
   static func make(feed: Feed, currentUserName: String) -> Self {
      if feed.transaction.recipient == currentUserName {
         if feed.transaction.isAnonymous {
            return .youGotAmountFromAnonym
         } else {
            return .someGotAmountFromSome
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

private extension FeedViewModels {
   func makeInfoDateLabel(feed: Feed) -> LabelModel {
      let dateAgoText = feed.time.timeAgoConverted
      let eventText = feed.transaction.isAnonymous ? "" : " • " + "Публичный перевод"
      let titleText = dateAgoText + eventText

      let dateLabel = LabelModel()
         .numberOfLines(0)
         .set(Design.state.label.caption)
         .textColor(Design.color.textSecondary)
         .text(titleText)

      return dateLabel
   }

   func makeInfoLabel(feed: Feed, type: FeedTransactType) -> LabelModel {
      let recipientName = "@" + feed.transaction.recipient
      let senderName = "@" + feed.transaction.sender
      let amountText = "\(feed.transaction.amount)" + " " + "спасибок"
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

extension String {
   func colored(_ color: UIColor) -> NSAttributedString {
      let attrStr = NSAttributedString(string: self, attributes: [.foregroundColor: color])
      return attrStr
   }
}
