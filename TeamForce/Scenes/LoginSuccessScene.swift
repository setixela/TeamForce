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
      .set(.contentMode(.scaleAspectFit))

   private lazy var headerModel = Design.label.headline4
      .set(.alignment(.center))
      .set(.numberOfLines(2))
      .set(.padding(UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.loginSuccess))

   private lazy var nextButton = ButtonModel(Design.State.button.default)
      .set(.title(Text.button.enterButton))

   private lazy var apiModel = GetProfileApiModel(apiEngine: Asset.service.apiEngine)
   private var userPromise: Promise<UserData>?
   private var userData: UserData?

   // MARK: - Start

   override func start() {
      mainViewModel.topStackModel.set(.alignment(.center))

      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            guard let userData = weakSelf?.userData else { return }

            Asset.router?.route(\.main, navType: .present, payload: userData)
         }
      
      vcModel?
         .onEvent(\.viewDidLoad) {
            weakSelf?.configure()
         }

      guard let token = weakSelf?.inputValue else { return }

      apiModel
         .onEvent(\.success) { userData in
            weakSelf?.userData = userData
         }
         .sendEvent(\.request, TokenRequest(token: token))
   }

   private func configure() {
      mainViewModel
         .set(Design.State.mainView.default)
         .set(.backColor(Design.color.background2))

      mainViewModel.topStackModel
         .set(.models([
            Spacer(size: 200),
            checkmarkIcon,
            headerModel,
            Spacer(size: 16),
            Spacer()
         ]))

      mainViewModel.bottomStackModel
         .set(.models([
            nextButton
         ]))
   }
}
