//
//  FeedViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 28.08.2022.
//

import ReactiveWorks
import UIKit

final class FeedViewModels<Design: DSP>: Designable {
   lazy var filterButtons = FeedFilterButtons<Design>()

   lazy var feedTableModel = TableItemsModel<Design>()
      .set_backColor(Design.color.background)
      .set(.presenters([
         feedCellPresenter,
         SpacerPresenter.presenter
      ]))

   private lazy var feedCellPresenter: Presenter<Feed, WrappedX<StackModel>> = Presenter<Feed, WrappedX<StackModel>> { [weak self] work in

      guard let self = self else { return }

      let feed = work.unsafeInput

      let isPersonal = feed.eventType.isPersonal
      let hasScope = feed.eventType.hasScope
      let isAnonTransact = feed.transaction.isAnonymous
      let texts = [feed.eventType.name,
                   feed.transaction.status,
                   feed.transaction.reason]

      let dateLabel = LabelModel()
         .set_numberOfLines(0)
         .set(Design.state.label.caption)
         .set_textColor(Design.color.textSecondary)
         .set_text(feed.time.dateConverted + " * " + texts[texts.count - 1])

      let infoLabel = LabelModel()
         .set_numberOfLines(0)
         .set(Design.state.label.caption)
         .set_textColor(
            Int.random(in: 0 ..< 2) == 1
               ? Design.color.text
               : Int.random(in: 0 ..< 2) == 1
               ? Design.color.textBrand
               : Design.color.success)
         .set_text(
            "@" + feed.transaction.recipient + " \(Int.random(in: 0 ..< 2) == 1 ? "получил" : "отправил") \(feed.transaction.amount) спасибок от \(feed.transaction.sender)" + "\n"
         )

      let icon = ImageViewModel()
         .set_image(Design.icon.avatarPlaceholder)
         .set_size(.square(Grid.x36.value))
         .set_cornerRadius(Grid.x36.value / 2)
      if let recipientPhoto = feed.transaction.recipientPhoto {
         icon.set_url("http://176.99.6.251:8888" + recipientPhoto)
      } else {
         if let nameFirstLetter = feed.transaction.recipientFirstName?.first,
            let surnameFirstLetter = feed.transaction.recipientSurname?.first
         {
            let text = String(nameFirstLetter) + String(surnameFirstLetter)
            let image = text.drawImage(backColor: Design.color.backgroundBrand)
            icon.set_image(image)
         }
      }

      let tagBlock = StackModel()
         .set_axis(.horizontal)
         .set_spacing(4)

      let messageButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.messageCloud)
            $1.set_text(String.randomInt(500))
         }

      let likeButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.like)
            $1.set_text(String.randomInt(500))
         }

      let dislikeButton = ReactionButton<Design>()
         .setAll {
            $0.set_image(Design.icon.dislike)
            $1.set_text(String.randomInt(500))
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

      let hashTagBlock = StackModel()
         .set_axis(.horizontal)
         .set_alignment(.leading)
         .set_distribution(.equalSpacing)
         .set_spacing(4)
         .set_arrangedModels(
            (0 ..< Int.random(in: 0 ..< 5)).map { _ -> UIViewModel in
               self.randomButton
            }
         )

      let infoBlock = StackModel()
         .set_spacing(Grid.x10.value)
         .set_axis(.vertical)
         .set_alignment(.leading)
         .set_arrangedModels([
            dateLabel,
            infoLabel,
            reactionsBlock,
            hashTagBlock
         ])

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
            .set_backColor(Int.random(in: 0 ..< 4) == 1 ? UIColor("#EDF8ED") : Design.color.background)
            .set_cornerRadius(Design.params.cornerRadiusSmall)
      )
      .set_padding(.verticalOffset(Grid.x16.value))

      work.success(result: cellStack)
   }
}

private extension FeedViewModels {
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
