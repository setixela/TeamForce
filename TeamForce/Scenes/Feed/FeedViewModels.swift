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

   // lazy var filterButtons = FeedFilterButtons<Design>()
   lazy var filterButtons = SlidedIndexButtons<Button4Event>(buttons:
      SecondaryButtonDT<Design>()
         .title("Все")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Благодарности")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Челленджи")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Победители")
         .font(Design.font.default)
         .height(16 + 38)
         .backColor(Design.color.background)
   )

   lazy var presenter = FeedPresenters<Design>()

   lazy var feedTableModel = TableItemsModel<Design>()
      .backColor(Design.color.background)
      .separatorColor(Design.color.cellSeparatorColor)
      .separatorStyle(.singleLine)
      .presenters(
         presenter.feedCellPresenter,
         SpacerPresenter.presenter
      )

   var userName = ""

   override func start() {
      // filterButtons.buttonAll.setMode(\.selected)
   }

   func applyState(_ state: State) {
      switch state {
      case .userName(let value):
         userName = value
         presenter.userName = value
      }
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

      let mutableStr = NSMutableAttributedString(attributedString: attributedText)
      mutableStr.addAttributes([NSAttributedString.Key.font: label.font!], range: NSRange(location: 0, length: attributedText.length))

      // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))

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
      let locationOfTouchInLabel = location(in: label)
      let textBoundingBox = layoutManager.usedRect(for: textContainer)
      let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                        y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
      let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                   y: locationOfTouchInLabel.y - textContainerOffset.y)
      let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
      return NSLocationInRange(indexOfCharacter, targetRange)
   }
}
