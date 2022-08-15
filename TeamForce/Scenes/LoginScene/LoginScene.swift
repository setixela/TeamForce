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
         $0.setImage(Design.icon.user)
      } setRight: {
         $0.setPlaceholder(Text.title.userName)
      }

   private let smsCodeInputModel = IconTextField<Design>()
      .setMain {
         $0.setImage(Design.icon.lock)
      } setRight: {
         $0.setPlaceholder(Text.title.enterSmsCode)
      }
      .setHidden(true)

   private lazy var getCodeButton = Design.button.inactive
      .setTitle(Text.button.getCodeButton)

   private lazy var loginButton = ButtonModel(Design.state.button.inactive)
      .set(.title(Text.button.enterButton))

   private lazy var bottomPanel = StackModel()
      .set(Design.state.stack.bottomPanel)
      .setCornerRadius(Design.params.cornerRadiusMedium)
      .setShadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.33))
      .setModels([
         Grid.x16.spacer,
         //  badgeModel,
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
            slf?.userNameInputModel.models.right.setText(text)
            slf?.getCodeButton.set(Design.state.button.default)
         }
         .onFail { (text: String) in
            slf?.userNameInputModel.models.right.setText(text)
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
            slf?.smsCodeInputModel.setHidden(true)
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
            Asset.router?.route(\.loginSuccess, navType: .push, payload: ())
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
            .setBackColor(Design.color.backgroundBrand)
            .setAlignment(.leading)
            .setModels([
               // spacer
               Grid.x16.spacer,
               // logo
               BrandLogoIcon<Design>(),
               // spacer
               Grid.x16.spacer,
               // title
               Design.label.headline5
                  .setText(Text.title.autorisation)
                  .setColor(Design.color.textInvert),
               // spacer
               Grid.x36.spacer
            ])
      } setDown: { bottomStack in
         bottomStack
            // чтобы сделать offset с тенью
            .setPadding(.top(-Grid.x16.value))
            .setModels([
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
         slf?.smsCodeInputModel.setHidden(true)
         slf?.userNameInputModel.setHidden(false)
         slf?.loginButton.setHidden(true)
         slf?.getCodeButton.setHidden(false)
      }
      onModeChanged(\.inputSmsCode) {
         slf?.smsCodeInputModel.setHidden(false)
         slf?.userNameInputModel.setHidden(true)
         slf?.loginButton.setHidden(false)
         slf?.getCodeButton.setHidden(true)
      }
      setMode(\.inputUserName)
   }
}

extension LoginScene: SceneModable {}
