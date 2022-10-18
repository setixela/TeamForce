//
//  DigitalThanksScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks

// MARK: - DigitalThanksScene

final class DigitalThanksScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Void
> {
   private lazy var enterButton = Design.button.default
      .title(Text.button.enterButton)

   // MARK: - Start

   override func start() {
      //
      configure()

      enterButton
         .on(\.didTap) {
            Asset.router?.route(.push, scene: \.login)
         }
   }

   private func configure() {
      mainVM
         .backColor(Design.color.background)

      mainVM.bodyStack
         .set(Design.state.stack.default)
         .set(.alignment(.center))
         .arrangedModels([
            DTLogoTitleX<Design>(),
            Grid.xxx.spacer,
            ImageViewModel()
               .image(Design.icon.introlIllustrate)
               .size(.square(280))
         ])

      mainVM.footerStack
         .set(Design.state.stack.bottomPanel)
         .arrangedModels([
            Grid.x1.spacer,
            TitleSubtitleY<Design>()
               .padding(.top(Design.params.titleSubtitleOffset))
               .setMain {
                  $0
                     .text(Text.title.digitalThanks)
                     .padBottom(Grid.x8.value)
               } setDown: {
                  $0.text(Text.title.digitalThanksAbout)
               },
            Grid.x1.spacer,
            enterButton
         ])
   }
}
