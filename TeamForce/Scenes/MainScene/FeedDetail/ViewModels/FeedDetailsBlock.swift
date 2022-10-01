//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.10.2022.
//

final class FeedDetailsBlock<Design: DSP>: StackModel, Designable {

   lazy var reasonLabel = SettingsTitleBodyDT<Design>()
      .setAll {
         $0
            .text("Cообщение")
            .set(Design.state.label.body4)
         $1
            .text("-")
            .set(Design.state.label.caption)
      }
      .hidden(true)

   lazy var infoStack = UserProfileStack<Design>()
      .arrangedModels([
         LabelModel()
            .text("ИНФОРМАЦИЯ")
            .set(Design.state.label.captionSecondary),
         reasonLabel,
         transactPhoto,
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

      backColor(.red)
      arrangedModels([
         infoStack,
         hashTagBlock,
         transactPhoto
      ])
   }
}
