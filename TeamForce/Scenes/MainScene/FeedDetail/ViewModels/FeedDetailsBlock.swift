//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

import ReactiveWorks

final class FeedDetailsBlock<Asset: AssetProtocol>: StackModel, Assetable {
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

   private var imageUrl: String?

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

      transactPhoto.models.down
         .set(.tapGesturing)
         .on(\.didTap, self) {
            Asset.router?.route(.presentModally(.automatic), scene: \.imageViewer, payload: $0.imageUrl)
         }
   }
}

extension FeedDetailsBlock: SetupProtocol {
   func setup(_ data: EventTransaction) {
      if let reason = data.reason, reason != "" {
         reasonLabel.text(reason)
         reasonStack.hidden(false)
      }

      if data.tags?.isEmpty == false {
         hashTagBlock.setup(data)
         hashTagBlock.hidden(false)
      }

      if let photoLink = data.photo {
         imageUrl = TeamForceEndpoints.urlBase + photoLink
         transactPhoto.models.down.url(TeamForceEndpoints.urlBase + photoLink)
         transactPhoto.hidden(false)
      }
   }
}
