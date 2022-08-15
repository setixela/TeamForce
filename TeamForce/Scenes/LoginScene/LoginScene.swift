//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks

struct LoginSceneMode<WeakSelf>: SceneModeProtocol {
   var inputUserName: VoidEvent?
   var inputSmsCode: VoidEvent?
}

// MARK: - LoginScene

final class LoginScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   Combos<SComboMD<StackModel, StackModel>>,
   Asset,
   Void
>, WorkableModel {
   var modes: LoginSceneMode<LoginScene> = .init()

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
         userNameInputModel,
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
      configureSceneStates()
      configureUserNameWorks()
      configureSmsCodeWorks()
   }
}

// MARK: - Configure works

private extension LoginScene {
   func configureUserNameWorks() {
      weak var slf = self
      let works = works

      // setup input field reactions
      userNameInputModel.models.right
         .onEvent(\.didEditingChanged)
         .onSuccess {
//            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .doNext(work: works.loginNameInputParse)
         .onSuccess { text in
            slf?.userNameInputModel.models.right.set_text(text)
            slf?.getCodeButton.set(Design.state.button.default)
         }
         .onFail { (text: String) in
            slf?.userNameInputModel.models.right.set_text(text)
            slf?.getCodeButton.set(Design.state.button.inactive)
         }

      // setup get code button reaction
      getCodeButton
         .onEvent(\.didTap)
         .doNext(work: works.authByName)
         .onSuccess {
            slf?.setMode(\.inputSmsCode)
         }
         .onFail {
            slf?.smsCodeInputModel.set_hidden(true)
//            weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }
   }

   func configureSmsCodeWorks() {
      weak var slf = self
      let works = works

      // setup input field reactions
      smsCodeInputModel.models.right
         //
         .onEvent(\.didEditingChanged)
         //
         .doNext(work: works.smsCodeInputParse)
         .onSuccess {
            slf?.smsCodeInputModel.models.right.set(.text($0))
            slf?.loginButton.set(Design.state.button.default)
         }.onFail { (text: String) in
            slf?.smsCodeInputModel.models.right.set(.text(text))
            slf?.loginButton.set(Design.state.button.inactive)
         }

      // setup login button reactions
      loginButton
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

// TODO: - Этот слой надо выносить из сцены

// MARK: - Configure presenting

private extension LoginScene {
   func configure() {
      mainVM.setMain { topStack in
         topStack
            .set(Design.state.stack.default)
            .set_backColor(Design.color.backgroundBrand)
            .set_alignment(.leading)
            .set_models([
               // spacer
               Grid.x16.spacer,
               // logo
               BrandLogoIcon<Design>(),
               // spacer
               Grid.x16.spacer,
               // title
               Design.label.headline5
                  .set_text(Text.title.autorisation)
                  .set_color(Design.color.textInvert),
               // spacer
               Grid.x36.spacer
            ])
      } setDown: { bottomStack in
         bottomStack
            // чтобы сделать offset с тенью
            .set_padding(.top(-Grid.x16.value))
            .set_models([
               // обернул в еще один стек, чтобы сделать offset с тенью
               bottomPanel
            ])
      }
   }
}

// MARK: - Configure scene states

private extension LoginScene {
   func configureSceneStates() {
      weak var slf = self

      onModeChanged(\.inputUserName) {
         slf?.smsCodeInputModel.set_hidden(true)
         slf?.userNameInputModel.set_hidden(false)
         slf?.loginButton.set_hidden(true)
         slf?.getCodeButton.set_hidden(false)
      }
      onModeChanged(\.inputSmsCode) {
         slf?.smsCodeInputModel.set_hidden(false)
         slf?.loginButton.set_hidden(false)
         slf?.getCodeButton.set_hidden(true)
      }
      setMode(\.inputUserName)
   }
}

extension LoginScene: SceneModable {}
