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

   lazy var scenario = LoginScenario(viewModels: LoginViewModels<Asset>(),
                                     works: LoginWorks<Asset>())

   // MARK: - Start

   override func start() {
      configure()
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
            scenario.vModels.userNameInputModel,
            scenario.vModels.smsCodeInputModel,
            scenario.vModels.getCodeButton,
            scenario.vModels.loginButton,
            Grid.xxx.spacer
         ])
   }
}


