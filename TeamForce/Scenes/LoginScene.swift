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

   private let userNameInputField = Combos()
      .setMain { (model: ImageViewModel) in
         model
            .setSize(.square(Grid.x24.value))
            .setImage(Design.icon.user)
      } setRight: { (model: TextFieldModel<Design>) in
         model
            .set(Design.state.textField.invisible)
            .setPlaceholder(Text.title.userName)
      }
      .set(Design.state.stack.inputContent)
      .setAlignment(.center)
      .setHeight(Design.params.buttonHeight)
      .setBackColor(Design.color.backgroundSecondary)

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
