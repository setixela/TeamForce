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
   Combos<SComboMD<StackModel, StackModel>>,
   Asset,
   Void
> {
   // MARK: - View Models

   private let userNameInputField = IconTextField<Design>()
      .setMain {
         $0.setImage(Design.icon.user)
      } setRight: {
         $0.setPlaceholder(Text.title.userName)
      }

   private let smsCodeInputField = IconTextField<Design>()
      .setMain {
         $0.setImage(Design.icon.lock)
      } setRight: {
         $0.setPlaceholder(Text.title.enterSmsCode)
      }

   private let nextButton = Design.button.inactive
      .setTitle(Text.button.getCodeButton)

   private lazy var bottomPanel = StackModel()
      .set(Design.state.stack.bottomPanel)
      .setCornerRadius(Design.params.cornerRadiusMedium)
      .setShadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.33))
      .setModels([
         Grid.x16.spacer,
         //  badgeModel,
         userNameInputField,
         smsCodeInputField,
         nextButton,
         Grid.xxx.spacer
      ])

   // MARK: - Use Cases

   private lazy var useCase = Asset.apiUseCase

   // MARK: - Start

   override func start() {
      configure()

      weak var weakSelf = self

      var loginName: String?

      nextButton
         .onEvent(\.didTap)
         .doInput {
            loginName
         }
         .onFail {
            print("login name is nil")
         }
         .doNext(usecase: useCase.login)
         .onSuccess {
            Asset.router?.route(\.verifyCode, navType: .push, payload: $0)
         }
         .onFail {
//            weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }

      userNameInputField.models.right
         .onEvent(\.didEditingChanged)
         .doNext {
//            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .doNext(worker: TelegramNickCheckerModel())
         .onSuccess { text in
            loginName = text // String(text.dropFirst())
            weakSelf?.userNameInputField.models.right
               .setText(text)
            weakSelf?.nextButton
               .set(Design.state.button.default)
         }
         .onFail { (text: String) in
            loginName = nil
            weakSelf?.userNameInputField.models.right
               .setText(text)
            weakSelf?.nextButton
               .set(Design.state.button.inactive)
         }
   }

   private func configure() {
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
               // обернули в еще один стек, чтобы сделать offset с тенью
               bottomPanel
            ])
      }
   }
}

