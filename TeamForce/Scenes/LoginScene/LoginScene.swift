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

   lazy var scenario = LoginScenario(
      works: LoginWorks<Asset>(),
      stateDelegate: viewModels.setState,
      events: LoginScenarioEvents(
         userNameStringEvent: viewModels.userNameInputModel.mainModel.textField.onEvent(\.didEditingChanged),
         smsCodeStringEvent: viewModels.smsCodeInputModel.mainModel.textField.onEvent(\.didEditingChanged),
         getCodeButtonEvent: viewModels.getCodeButton.onEvent(\.didTap),
         loginButtonEvent: viewModels.loginButton.onEvent(\.didTap)
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
         .set_text(Design.Text.title.autorisation)
      mainVM.bottomSubStack
         .set_arrangedModels([
            viewModels.userNameInputModel,
            viewModels.smsCodeInputModel,
            Spacer(Design.params.buttonsSpacingY),
            viewModels.getCodeButton,
            viewModels.loginButton,
            Grid.xxx.spacer
         ])
   }
}
