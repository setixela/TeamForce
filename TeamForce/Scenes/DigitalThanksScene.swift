//
//  DigitalThanksScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - DigitalThanksScene

final class DigitalThanksScene: BaseSceneModel<
   DefaultVCModel,
   StackModel,
   ProductionAsset,
   Void
> {
   //
   private lazy var headerModel = Design.label.headline3
      .set(.numberOfLines(2))
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text(text.title.make(\.digitalThanks)))
      .set(.alignment(.center))

   private lazy var enterButton = Design.button.default
      .set(.title(text.button.make(\.enterButton)))

   private lazy var registerButton = Design.button.transparent
      .set(.title(text.button.make(\.registerButton)))

   // MARK: - Start

   override func start() {
      print("start()")
      //
      mainViewModel.set(Design.State.mainView.default)

      enterButton
         .onEvent(\.didTap) {
            print("WORKS!")
            Asset.router?.route(\.login, navType: .push)
         }

      registerButton
         .onEvent(\.didTap) {
            Asset.router?.route(\.register, navType: .push)
         }

      presentModels()
   }

   private func presentModels() {
      mainViewModel.sendEvent(\.addViewModels, [
         Spacer(size: 100),
         headerModel,
         enterButton,
         Spacer(size: 16),
         registerButton,
         Spacer()
      ])
   }
}
