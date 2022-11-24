//
//  VerifyScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 15.11.2022.
//

import ReactiveWorks

// MARK: - VerifyScene

final class VerifyScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksBrandedVM<Asset.Design>,
   Asset,
   AuthResult
>, Scenarible {
   //

   private lazy var viewModels = VerifyViewModels<Design>()

   lazy var scenario: Scenario = VerifyScenario(
      works: VerifyWorks<Asset>(),
      stateDelegate: viewModels.stateDelegate,
      events: VerifyScenarioEvents(
         saveInput: on(\.input),
         smsCodeStringEvent: viewModels.smsCodeInputModel.mainModel.textField.on(\.didEditingChanged),
         loginButtonEvent: viewModels.loginButton.on(\.didTap)
      )
   )

   // MARK: - Start

   override func start() {
      configure()
      Asset.router?.initColors()

      viewModels.setState(.inputSmsCode)
      scenario.start()
   }
}

// MARK: - Configure presenting

private extension VerifyScene {
   func configure() {
      mainVM.header
         .text(Design.Text.title.autorisation)
      mainVM.bodyStack
         .arrangedModels([
            viewModels.smsCodeInputModel,
            Spacer(Design.params.buttonsSpacingY),
            viewModels.loginButton,
            viewModels.activityIndicator,
            Grid.xxx.spacer
         ])
   }
}


