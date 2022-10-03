//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

final class FeedDetailsBlock<Design: DSP>: StackModel, Designable {
   private lazy var reasonLabel = LabelModel()
      .text("Текст")
      .numberOfLines(0)
      .set(Design.state.label.body4)

   private lazy var reasonStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("За что")
            .set(Design.state.label.subtitleSecondary),
         reasonLabel
      ])
      .distribution(.fill)
      .alignment(.leading)
      .hidden(true)

   private lazy var hashTagBlock = HashTagsScrollModel<Design>()
      .hidden(true)

   private lazy var transactPhoto = Combos<SComboMD<LabelModel, ImageViewModel>>()
      .setAll {
         $0
            .padBottom(10)
            .set(Design.state.label.subtitleSecondary)
            .text("Фотография")
         $1
            .image(Design.icon.transactSuccess)
            .height(130)
            .width(130)
            .contentMode(.scaleAspectFill)
            .cornerRadius(Design.params.cornerRadiusSmall)
      }
      .alignment(.leading)
      .hidden(true)

   override func start() {
      super.start()

      spacing(18)
      arrangedModels([
         Spacer(8),
         reasonStack,
         hashTagBlock,
         transactPhoto
      ])
   }
}

extension FeedDetailsBlock: SetupProtocol {
   func setup(_ data: Feed) {
      if let reason = data.transaction.reason, reason != "" {
         reasonLabel.text(reason)
         reasonStack.hidden(false)
      }

      if data.transaction.tags?.isEmpty == false {
         hashTagBlock.setup(data)
         hashTagBlock.hidden(false)
      }

      if let photoLink = data.transaction.photo {
         transactPhoto.models.down.url(TeamForceEndpoints.urlBase + photoLink)
         transactPhoto.hidden(false)
      }
   }
}
