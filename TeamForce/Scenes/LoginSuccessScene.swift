//
//  LoginSuccessScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - LoginSuccessScene

final class LoginSuccessScene: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   Void
> {
   //
   private lazy var checkmarkIcon = ImageViewModel()
      .set(.size(.init(width: 48, height: 48)))
      .set(.image(Icons().make(\.checkCircle)))

   private lazy var headerModel = Design.label.headline4
      .set(.alignment(.center))
      .set(.numberOfLines(2))
      .set(.padding(UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)))
      .set(.text(text.title.loginSuccess))

   private lazy var nextButton = ButtonModel(Design.State.button.default)
      .set(.title(text.button.enterButton))

   override func start() {
      mainViewModel.stackModel.set(.alignment(.center))

      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            Asset.router?.route(\.main, navType: .present)
         }

      vcModel?
         .onEvent(\.viewDidLoad) {
            weakSelf?.presentModels()
         }
   }

   private func presentModels() {
      mainViewModel
         .sendEvent(\.addViewModels, [
            Spacer(size: 100),
            checkmarkIcon,
            headerModel,
            Spacer(size: 16),
            Spacer()
         ])
         .sendEvent(\.addBottomPanelModel, nextButton)
   }
}
