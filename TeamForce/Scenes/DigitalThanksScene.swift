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
   //
   private lazy var logoTitle = DTLogoTitleX<Asset>()
      .centeredX()

   private lazy var illustration = ImageViewModel()
      .setImage(Design.icon.introlIllustrate)
      .setWidth(300)

   private lazy var titleSubtitle = TitleSubtitleY<Design>()
      .setMain {
         $0.setText(Text.title.digitalThanks)
      } setDown: {
         $0.setText(Text.title.digitalThanksAbout)
      }

   private lazy var enterButton = Design.button.default
      .set(.title(Text.button.enterButton))

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
      mainViewModel
         .setBackColor(Design.color.background2)

      mainViewModel.topStackModel
         .set(Design.state.stack.default)
         .setModels([
            Spacer(Design.params.globalTopOffset),
            logoTitle,
            Spacer(32),
            illustration,
            Spacer(64),
            titleSubtitle,
            Spacer()
         ])

      mainViewModel.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .setSpacing(Design.params.buttonsSpacingY)
         .setModels([
            enterButton
         ])
   }
}
