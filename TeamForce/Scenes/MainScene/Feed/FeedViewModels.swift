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

      work.success(result: cellStack)
   }
}

private enum FeedTransactType {
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
         
      //infoLabel.makeTappable()
      //infoLabel.makePartsClickable(user1: recipientName, user2: senderName)
      
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

extension UITapGestureRecognizer {
   
   func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
       guard let attributedText = label.attributedText else { return false }

       let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
       mutableStr.addAttributes([NSAttributedString.Key.font : label.font!], range: NSRange.init(location: 0, length: attributedText.length))
       
       // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
       let paragraphStyle = NSMutableParagraphStyle()
       paragraphStyle.alignment = .center
       mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedText.length))

       // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
       let layoutManager = NSLayoutManager()
       let textContainer = NSTextContainer(size: CGSize.zero)
       let textStorage = NSTextStorage(attributedString: mutableStr)
       
       // Configure layoutManager and textStorage
       layoutManager.addTextContainer(textContainer)
       textStorage.addLayoutManager(layoutManager)
       
       // Configure textContainer
       textContainer.lineFragmentPadding = 0.0
       textContainer.lineBreakMode = label.lineBreakMode
       textContainer.maximumNumberOfLines = label.numberOfLines
       let labelSize = label.bounds.size
       textContainer.size = labelSize
       
       // Find the tapped character location and compare it to the specified range
       let locationOfTouchInLabel = self.location(in: label)
       let textBoundingBox = layoutManager.usedRect(for: textContainer)
       let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                         y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
       let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                    y: locationOfTouchInLabel.y - textContainerOffset.y);
       let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
       return NSLocationInRange(indexOfCharacter, targetRange)
   }
   
}
