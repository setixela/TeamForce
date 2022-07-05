//
//  LoginSuccessScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import PromiseKit
import UIKit

// MARK: - LoginSuccessScene

final class LoginSuccessScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   String
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

   private lazy var apiModel = GetProfileApiModel(apiEngine: Asset.service.apiEngine)
   private var userPromise: Promise<UserData>?

   // MARK: - Start
   
   override func start() {
      print("Start jdsahdjkasfhkfh")
      mainViewModel.stackModel.set(.alignment(.center))

      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            guard let promise = weakSelf?.userPromise else { return }
            Asset.router?.route(\.main, navType: .present, payload: promise)
         }

      presentModels()

      guard let token = weakSelf?.inputValue else { return }

      apiModel
         .onEvent(\.success) { promise in
            weakSelf?.userPromise = promise
         }
         .sendEvent(\.request, TokenRequest(token: token))
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
