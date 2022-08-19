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
      .set_title(Text.button.enterButton)

   // MARK: - Start

   override func start() {
      //
      configure()

      enterButton
         .onEvent(\.didTap) {
            Asset.router?.route(\.login, navType: .push)
         }
   }

   private func configure() {
      mainVM
         .set_backColor(Design.color.background)

      mainVM.topStackModel
         .set(Design.state.stack.default)
         .set(.alignment(.center))
         .set_arrangedModels([
            DTLogoTitleX<Design>(),
            Grid.xxx.spacer,
            ImageViewModel()
               .set_image(Design.icon.introlIllustrate)
               .set_size(.square(280))
         ])

      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .set_arrangedModels([
            Grid.x1.spacer,
            TitleSubtitleY<Design>()
               .set_padding(.top(Design.params.titleSubtitleOffset))
               .setMain {
                  $0.set_text(Text.title.digitalThanks)
               } setDown: {
                  $0.set_text(Text.title.digitalThanksAbout)
               },
            Grid.x1.spacer,
            enterButton
         ])
   }
}
