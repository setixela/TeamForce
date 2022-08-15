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
         .set_models([
            // logo model
            DTLogoTitleX<Design>()
               .set(.invert)
               .lefted(), // выравниваем по левому краю ))
            // spacer
            Grid.xxx.spacer
         ])
         .set_backImage(Design.icon.introlIllustrate)

      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)

         .set_models([
            // spacer
            Grid.x1.spacer,
            // title subtitle
            TitleSubtitleY<Design>()
               .setMain {
                  $0.set_text(Text.title.digitalThanks)
               } setDown: {
                  $0.set_text(Text.title.digitalThanksAbout)
               },
            // spacer
            Grid.x1.spacer,
            // enter button
            enterButton
         ])
   }
}
