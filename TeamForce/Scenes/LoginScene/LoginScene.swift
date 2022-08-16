//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks

// MARK: - LoginScene

final class LoginScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   Void
>, Scenaryable {
   //

   lazy var scenario = LoginScenario(viewModels: viewModels,
                                     works: LoginWorks<Asset>())

   // MARK: - Start

   private lazy var viewModels = LoginViewModels<Asset>()

   override func start() {
      configure()
      viewModels.setMode(.inputUserName)
      scenario.start()
   }
}

// MARK: - Configure presenting

private extension LoginScene {
   func configure() {
      mainVM.header
         .set_text(Design.Text.title.autorisation)
      mainVM.bottomSubStack
         .set_models([
            viewModels.userNameInputModel,
            viewModels.smsCodeInputModel,
            viewModels.getCodeButton,
            viewModels.loginButton,
            Grid.xxx.spacer
         ])
   }
}


