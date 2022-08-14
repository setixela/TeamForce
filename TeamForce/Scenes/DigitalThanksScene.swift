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
      .set(.image(Design.icon.make(\.introlIllustrate)))
      .set(.width(300))

   private lazy var titleSubtitle = TitleSubtitleY<Design>()
      .setMain {
         $0.set(.text(Text.title.digitalThanks))
      } setDown: {
         $0.set(.text(Text.title.digitalThanksAbout))
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
         .set(.backColor(Design.color.background2))

      mainViewModel.topStackModel
         .set(Design.state.stack.default)
         .set(.models([
            Spacer(Design.params.globalTopOffset),
            logoTitle,
            Spacer(32),
            illustration,
            Spacer(64),
            titleSubtitle,
            Spacer()
         ]))

      mainViewModel.bottomStackModel
         .set(.spacing(Design.params.buttonsSpacingY))
         .set(Design.state.stack.bottomPanel)
         .set(.models([
            enterButton
         ]))
   }
}
