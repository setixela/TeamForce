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

   private lazy var viewModels = LoginViewModels<Asset>()

   lazy var scenario = LoginScenario(
      works: LoginBackstage<Asset>(),
      events: LoginScenarioEvents(
         userNameStringEvent: viewModels.userNameInputModel.textField.onEvent(\.didEditingChanged),
         smsCodeStringEvent: viewModels.smsCodeInputModel.textField.onEvent(\.didEditingChanged),
         getCodeButtonEvent: viewModels.getCodeButton.onEvent(\.didTap),
         loginButtonEvent: viewModels.loginButton.onEvent(\.didTap)
      )
   )

   // MARK: - Start

   override func start() {
      configure()

      let fun = viewModels.setState
      test(fun)

      viewModels.setState(.inputUserName)
      scenario.start(stateMachineFunc: viewModels.setState)
   }

   func test(_ fun: @escaping (LoginSceneState) -> Void) {
      fun(.inputUserName)
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
