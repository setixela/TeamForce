//
//  LoginSuccessScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit
import ReactiveWorks

// MARK: - LoginSuccessScene

final class LoginSuccessScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   String
> {
   //
   private lazy var checkmarkIcon = ImageViewModel()
      .set(.size(.init(width: 48, height: 48)))
      .set(.image(Design.icon.checkCircle))
      .set(.contentMode(.scaleAspectFit))

   private lazy var headerModel = Design.label.headline4
      .set(.alignment(.center))
      .set(.numberOfLines(2))
      .set(.padding(UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.loginSuccess))

   private lazy var nextButton = ButtonModel(Design.state.button.default)
      .set(.title(Text.button.enterButton))

   private lazy var apiModel = ProfileApiWorker(apiEngine: Asset.service.apiEngine)
   private var userData: UserData?

   // MARK: - Start

   override func start() {

      mainViewModel.topStackModel.set(.alignment(.center))

      configure()

      weak var weakSelf = self

      nextButton
         .onEvent(\.didTap) {
            guard let userData = weakSelf?.userData else { return }

            Asset.router?.route(\.main, navType: .present, payload: userData)
         }

      guard let token = inputValue else { return }

      apiModel
         .doAsync(TokenRequest(token: token))
         .onSuccess({ userData in
            weakSelf?.userData = userData
         })
   }

   private func configure() {
      mainViewModel
         .set(Design.state.stack.default)
         .set(.backColor(Design.color.background2))

      mainViewModel.topStackModel
         .set(.models([
            Spacer(200),
            checkmarkIcon,
            headerModel,
            Spacer(16),
            Spacer()
         ]))

      mainViewModel.bottomStackModel
         .set(.models([
            nextButton
         ]))
   }
}
