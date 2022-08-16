//
//  LoginScenery.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 16.08.2022.
//

import ReactiveWorks

struct LoginViewModels<Design: DesignProtocol> {
   let userNameInputModel: IconTextField<Design>
   let smsCodeInputModel: IconTextField<Design>
   let getCodeButton: ButtonModel
   let loginButton: ButtonModel
}

struct LoginSceneryCase: SceneModeProtocol {
   var inputUserName: VoidEvent?
   var inputSmsCode: VoidEvent?
}

final class LoginScenery<Asset: AssetProtocol>:
   BaseScenery<LoginViewModels<Asset.Design>, LoginWorks<Asset>>
{

   var modes: LoginSceneryCase = .init()

   override func start() {
      configure()

      let works = works
      let vModels = vModels

      // setup input field reactions
      vModels.userNameInputModel.models.right
         .onEvent(\.didEditingChanged)
         .onSuccess {
            //            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .doNext(work: works.loginNameInputParse)
         .onSuccess { text in
            vModels.userNameInputModel.models.right.set_text(text)
            vModels.getCodeButton.set(Asset.Design.state.button.default)
         }
         .onFail { (text: String) in
            vModels.userNameInputModel.models.right.set_text(text)
            vModels.getCodeButton.set(Asset.Design.state.button.inactive)
         }

      // setup get code button reaction
      vModels.getCodeButton
         .onEvent(\.didTap)
         .doNext(work: works.authByName)
         .onSuccess { [weak self] in
            self?.setMode(\.inputSmsCode)
         }
         .onFail {
            vModels.smsCodeInputModel.set_hidden(true)
            //            weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }

      // setup input field reactions
      vModels.smsCodeInputModel.models.right
      //
         .onEvent(\.didEditingChanged)
      //
         .doNext(work: works.smsCodeInputParse)
         .onSuccess {
            vModels.smsCodeInputModel.models.right.set(.text($0))
            vModels.loginButton.set(Asset.Design.state.button.default)
         }.onFail { (text: String) in
            vModels.smsCodeInputModel.models.right.set(.text(text))
            vModels.loginButton.set(Asset.Design.state.button.inactive)
         }

      // setup login button reactions
      vModels.loginButton
      //
         .onEvent(\.didTap)
      //
         .doNext(work: works.verifyCode)
         .onFail {
            print("Verify api error")
            // weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }
         .doNext(work: works.saveLoginResults)
         .onSuccess {
             Asset.router?.route(\.main, navType: .present, payload: ())
         }
         .onFail {
            print("Save login results to persistence error")
            // weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }
   }
}

// MARK: - Configure scene states

 extension LoginScenery: SceneModable {
    private func configure() {
      let vModels = vModels

      onModeChanged(\.inputUserName) {
         vModels.smsCodeInputModel.set_hidden(true)
         vModels.userNameInputModel.set_hidden(false)
         vModels.loginButton.set_hidden(true)
         vModels.getCodeButton.set_hidden(false)
      }
      onModeChanged(\.inputSmsCode) {
         vModels.smsCodeInputModel.set_hidden(false)
         vModels.loginButton.set_hidden(false)
         vModels.getCodeButton.set_hidden(true)
      }
      setMode(\.inputUserName)
   }
}

