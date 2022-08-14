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
   DoubleStacksModel,
   Asset,
   Void
> {
   // MARK: - View Models

   private let coverViewModel = CoverViewModel<Asset>()
      .setBackImage(Design.icon.introlIllustrate)

   private let headerModel = Design.label.headline4
      .setPadding(.init(top: 12, left: 0, bottom: 24, right: 0))
      .setText(Text.title.enter)

   private let subtitleModel = Design.label.subtitle
      .setPadding(.init(top: 0, left: 0, bottom: 32, right: 0))
      .setText(Text.title.enterTelegramName)
      .setNumberOfLines(2)

   private let nextButton = Design.button.inactive
      .setTitle(Text.button.getCodeButton)

   private let badgeModel = BadgeModel<Asset>()

   private let loginTextField = TextFieldModel<Design>(Design.state.textField.default)
      .setPlaceholder("")

   // MARK: - Use Cases

   private lazy var useCase = Asset.apiUseCase

   // MARK: - Private

   private let telegramNickParser = TelegramNickCheckerModel()
   // private var loginName: String?

   // MARK: - Start

   override func start() {
      configure()

      weak var weakSelf = self

      var loginName: String?

      badgeModel
         .setLabels(title: Text.title.userName,
                    placeholder: "@" + Text.title.userName,
                    error: Text.title.wrongUsername)

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
            weakSelf?.badgeModel.changeState(to: BadgeState.error)
         }

      badgeModel.textFieldModel
         .onEvent(\.didEditingChanged)
         .doNext {
            weakSelf?.badgeModel.changeState(to: BadgeState.default)
         }
         .doNext(worker: TelegramNickCheckerModel())
         .onSuccess { text in
            loginName = text // String(text.dropFirst())
            weakSelf?.badgeModel.textFieldModel
               .setText(text)
            weakSelf?.nextButton
               .set(Design.state.button.default)
         }
         .onFail { (text: String) in
            loginName = nil
            weakSelf?.badgeModel.textFieldModel
               .setText(text)
            weakSelf?.nextButton
               .set(Design.state.button.inactive)
         }
   }

   private func configure() {
//      mainVM
//         .setBackColor(Design.color.backgroundBrand)

      mainVM.topStackModel
         .set(Design.state.stack.default)
         .setBackColor(Design.color.backgroundBrand)
         .setAlignment(.leading)
         .setModels([
            // spacer
            Grid.x36.spacer,
            // logo
            BrandLogoIcon<Design>(),
            // spacer
            Grid.x36.spacer,
            // title
            Design.label.headline5
               .setText(Text.title.autorisation)
               .setColor(Design.color.textInvert),
            // spacer
            Grid.x36.spacer,
         ])

      mainVM.bottomStackModel
         .set(Design.state.stack.bottomPanel)
         .setModels([
            badgeModel,
            loginTextField,
            nextButton,
            Spacer(),
         ])
   }
}
