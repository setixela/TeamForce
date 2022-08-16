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
>, Scenario {
   //

   lazy var scenario = LoginScenery(viewModels: LoginViewModels<Design>(
      userNameInputModel: userNameInputModel,
      smsCodeInputModel: smsCodeInputModel,
      getCodeButton: getCodeButton,
      loginButton: loginButton
   ), works: LoginWorks<Asset>())

   // MARK: - View Models

   private let userNameInputModel = IconTextField<Design>()
      .setMain {
         $0.set_image(Design.icon.user)
      } setRight: {
         $0.set_placeholder(Text.title.userName)
      }

   private let smsCodeInputModel = IconTextField<Design>()
      .setMain {
         $0.set_image(Design.icon.lock)
      } setRight: {
         $0.set_placeholder(Text.title.enterSmsCode)
      }
      .set_hidden(true)

   private lazy var getCodeButton = Design.button.inactive
      .set_title(Text.button.getCodeButton)

   private lazy var loginButton = ButtonModel(Design.state.button.inactive)
      .set(.title(Text.button.enterButton))

   private lazy var bottomPanel = StackModel()
      .set(Design.state.stack.bottomShadowedPanel)
      .set_models([
         userNameInputModel, // перенос на стек короче автоматически 2 слоя
         smsCodeInputModel,
         getCodeButton,
         loginButton,
         Grid.xxx.spacer
      ])

   // MARK: - Use Cases

   let works = LoginWorks<Asset>()

   // MARK: - Start

   override func start() {
      configure()
      scenario.start()
   }
}

// MARK: - Configure presenting

private extension LoginScene {
   func configure() {
      mainVM
         .setMain { _ in } setDown: {
            $0.set_models([
               bottomPanel
            ])
         }
         .header.set_text(Design.Text.title.autorisation)
   }
}
