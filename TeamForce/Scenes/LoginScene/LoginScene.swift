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
>, Scenarible {
   //

   private lazy var viewModels = LoginViewModels<Design>()

   lazy var scenario: Scenario = LoginScenario(
      works: LoginWorks<Asset>(),
      stateDelegate: viewModels.stateDelegate,
      events: LoginScenarioEvents(
         userNameStringEvent: viewModels.userNameInputModel.mainModel.textField.on(\.didEditingChanged),
         smsCodeStringEvent: viewModels.smsCodeInputModel.mainModel.textField.on(\.didEditingChanged),
         getCodeButtonEvent: viewModels.getCodeButton.on(\.didTap)
//         loginButtonEvent: viewModels.loginButton.on(\.didTap)
      )
   )

   // MARK: - Start

   override func start() {
      configure()

      viewModels.setState(.inputUserName)
      scenario.start()
   }
}

// MARK: - Configure presenting

private extension LoginScene {
   func configure() {
      mainVM.header
         .text(Design.Text.title.autorisation)
      mainVM.bodyStack
         .arrangedModels([
            viewModels.userNameInputModel,
            viewModels.smsCodeInputModel,
            Spacer(Design.params.buttonsSpacingY),
            viewModels.getCodeButton,
            viewModels.loginButton,
            viewModels.activityIndicator,
            Grid.xxx.spacer
         ])
   }
}


