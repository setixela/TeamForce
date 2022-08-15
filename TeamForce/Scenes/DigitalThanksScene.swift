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
      .setTitle(Text.button.enterButton)

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
         .setBackColor(Design.color.background)

      mainVM.topStackModel
         .set(Design.state.stack.default)
         .setModels([
            // logo model
            DTLogoTitleX<Design>()
               .set(.invert)
               .lefted(), // выравниваем по левому краю ))
            // spacer
            Grid.xxx.spacer
         ])
         .setBackImage(Design.icon.introlIllustrate)

      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)

         .setModels([
            // spacer
            Spacer(1),
            // title subtitle
            TitleSubtitleY<Design>()
               .setMain {
                  $0.setText(Text.title.digitalThanks)
               } setDown: {
                  $0.setText(Text.title.digitalThanksAbout)
               },
            // spacer
            Spacer(1),
            // enter button
            enterButton
         ])
   }
}
