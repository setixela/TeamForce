//
//  DigitalThanksScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

// MARK: - DigitalThanksScene

final class DigitalThanksScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackModel,
   Asset,
   Void
> {
   //
   private lazy var headerModel = Design.label.headline3
      .set(.numberOfLines(2))
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text(Text.title.make(\.digitalThanks)))
      .set(.alignment(.center))

   private lazy var enterButton = Design.button.default
      .set(.title(Text.button.make(\.enterButton)))

   // MARK: - Start

   override func start() {
      //
      configure()

      mainViewModel.set(Design.State.mainView.default)

      enterButton
         .onEvent(\.didTap) {
            Asset.router?.route(\.login, navType: .push)
         }
   }

   private func configure() {
      mainViewModel
         //.set(Design.State.mainView.default)
         .set(.alignment(.leading))
         .set(.distribution(.equalSpacing))
         .set(.backColor(Design.color.background2))
         .set(.models([
            Spacer(100),
            LogoTitleVM<Asset>(),
            headerModel,
            enterButton,
            Spacer(16),
            Spacer()
         ]))
   }
}

final class LogoTitleVM<Asset: AssetProtocol>:
   Combos<SComboMR<ImageViewModel, ImageViewModel>>,
   Assetable
{
   let mainModel: ImageViewModel = .init()
   let rightModel: ImageViewModel = .init()

   override func start() {
      setMain {
         $0
            .set(.image(Design.icon.make(\.logo)))
            .set(.size(.square(32)))

      } setRight: {
         $0
            .set(.image(Design.icon.make(\.logoTitle)))
            .set(.padding(.left(12)))
      }
   }
}
