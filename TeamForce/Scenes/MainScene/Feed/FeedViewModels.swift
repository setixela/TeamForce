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
      .set_backColor(Design.color.background)
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

   private lazy var feedCellPresenter: Presenter<Feed, WrappedX<StackModel>> = Presenter<Feed, WrappedX<StackModel>> { [weak self] work in

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
         .set_axis(.horizontal)
         .set_spacing(4)

      let messageButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.messageCloud)
            $1.set_text("0")
         }

      let likeButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.like)
            $1.set_text("0")
         }

      let dislikeButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.dislike)
            $1.set_text("0")
         }

      let reactionsBlock = StackModel()
         .set_axis(.horizontal)
         .set_alignment(.leading)
         .set_distribution(.equalSpacing)
         .set_spacing(4)
         .set_arrangedModels([
            messageButton,
            likeButton,
            dislikeButton
         ])

//      let hashTagBlock = StackModel()
//         .set_axis(.horizontal)
//         .set_alignment(.leading)
//         .set_distribution(.equalSpacing)
//         .set_spacing(4)
//         .set_arrangedModels(
//            (0 ..< Int.random(in: 0 ..< 5)).map { _ -> UIViewModel in
//               self.randomButton
//            }
//         )

      let infoBlock = StackModel()
         .set_spacing(Grid.x10.value)
         .set_axis(.vertical)
         .set_alignment(.leading)
         .set_arrangedModels([
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
            .set_padding(.outline(Grid.x8.value))
            .set_spacing(Grid.x12.value)
            .set_axis(.horizontal)
            .set_alignment(.top)
            .set_arrangedModels([
               icon,
               infoBlock
            ])
            .set_backColor(backColor)
            .set_cornerRadius(Design.params.cornerRadiusSmall)
      )
      .set_padding(.verticalOffset(Grid.x16.value))

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
         .set_numberOfLines(0)
         .set(Design.state.label.caption)
         .set_textColor(Design.color.textSecondary)
         .set_text(titleText)

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
         .set_numberOfLines(0)
         .set(Design.state.label.caption)
         .set_textColor(Design.color.iconBrand)
         .set_attributedText(infoText)

      return infoLabel
   }

   func makeIcon(feed: Feed) -> ImageViewModel {
      let icon = ImageViewModel()
         .set_contentMode(.scaleAspectFill)
         .set_image(Design.icon.avatarPlaceholder)
         .set_size(.square(Grid.x36.value))
         .set_cornerRadius(Grid.x36.value / 2)
      if let recipientPhoto = feed.transaction.photoUrl {
         // TODO: - Ohohoho
         icon.set_url(recipientPhoto)
      } else {
         if let nameFirstLetter = feed.transaction.recipientFirstName?.first,
            let surnameFirstLetter = feed.transaction.recipientSurname?.first
         {
            let text = String(nameFirstLetter) + String(surnameFirstLetter)
            DispatchQueue.global(qos: .background).async {
               let image = text.drawImage(backColor: Design.color.backgroundBrand)
               DispatchQueue.main.async {
                  icon
                     .set_backColor(Design.color.backgroundBrand)
                     .set_image(image)
               }
            }
         }
      }

      return icon
   }

   func makeIGet(sender: String, amount: String) -> NSAttributedString {
      NSAttributedString()
   }

   func makeSomeGetFromSome(sender: String, recipient: String, amount: String) -> NSAttributedString {
      NSAttributedString()
   }

   func makeSomeGetFromAnonym(recipient: String, amount: String) -> NSAttributedString {
      NSAttributedString()
   }

   var randomButton: LabelModel {
      LabelModel()
         .set(Design.state.label.caption2)
         .set_textColor(Design.color.textInfo)
         .set_backColor(Design.color.backgroundInfoSecondary)
         .set_cornerRadius(Design.params.cornerRadiusMini)
         .set_height(26)
         .set_padding(.sideOffset(4))
         .set_text("# " + randomWords[Int.random(in: 0 ..< randomWords.count)])
   }

   var randomWords: [String] { [
      Design.Text.title.autorisation,
      Design.Text.title.canceled,
      Design.Text.title.digitalThanks,
      Design.Text.title.enter,
      Design.Text.title.register,
      Design.Text.title.sendThanks,

      Design.Text.button.enterButton,
      Design.Text.button.nextButton,
      Design.Text.button.registerButton,
      Design.Text.button.getCodeButton,
      Design.Text.button.changeUserButton,
      Design.Text.button.sendButton,
      Design.Text.button.toTheBeginingButton,
      Design.Text.button.logoutButton
   ] }
}

extension String {
   func colored(_ color: UIColor) -> NSAttributedString {
      let attrStr = NSAttributedString(string: self, attributes: [.foregroundColor: color])
      return attrStr
   }
}
