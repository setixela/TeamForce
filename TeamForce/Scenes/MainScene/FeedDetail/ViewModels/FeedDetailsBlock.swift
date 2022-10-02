//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

final class FeedDetailsBlock<Design: DSP>: StackModel, Designable {
   lazy var reasonLabel = LabelModel()
      .text("Текст")
      .set(Design.state.label.body4)

   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("За что")
            .set(Design.state.label.captionSecondary),
         reasonLabel,
         Grid.xxx.spacer
      ])
      .distribution(.fill)
      .alignment(.leading)
      .hidden(true)


   lazy var hashTagBlock = ScrollViewModelX()
      .set(.spacing(4))
      .set(.hideHorizontalScrollIndicator)

   lazy var transactPhoto = Combos<SComboMD<LabelModel, ImageViewModel>>()
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

   override func start() {
      super.start()

      arrangedModels([
         infoStack,
         hashTagBlock,
         transactPhoto
      ])
   }
}

extension FeedDetailsBlock: SetupProtocol {
   func setup(_ data: Feed) {
      if let reason = data.transaction.reason, reason != "" {
         reasonLabel.text(reason)
         infoStack.hidden(false)
      }

      if let photoLink = data.transaction.photoUrl {
         transactPhoto.models.down.url(TeamForceEndpoints.urlBase + photoLink)
         transactPhoto.hidden(false)
         infoStack.hidden(false)
      }
   }
}
