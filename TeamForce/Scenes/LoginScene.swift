//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks
import UIKit

// MARK: - LoginScene

final class LoginScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Void
> {
   // MARK: - View Models

   private let coverViewModel = CoverViewModel<Asset>()
      .set(.backImage(Design.icon.make(\.introlIllustrate)))

   private let headerModel = Design.label.headline4
      .set(.padding(.init(top: 12, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.enter))

   private let subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 32, right: 0)))
      .set(.text(Text.title.enterTelegramName))
      .set(.numberOfLines(2))

   private let nextButton = Design.button.inactive
      .set(.title(Text.button.getCodeButton))

   private let badgeModel = BadgeModel<Asset>()

   private let loginTextField = TextFieldModel()

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
            weakSelf?.badgeModel.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.state.button.default)
         }
         .onFail { (text: String) in
            loginName = nil
            weakSelf?.badgeModel.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.state.button.inactive)
         }
   }

   private func configure() {
      mainViewModel
         .set(.backColor(Design.color.background))

      mainViewModel.topStackModel
         .set(Design.state.stack.default)
         .set(.alignment(.leading))
         .set(.models([
            Spacer(Design.Params.globalTopOffset),
            DTLogoTitleXVM<Asset>(),
            Spacer(36),
            TitleSubtitleYVM<Design>()
               .setMain {
                  $0
                     .set(.alignment(.left))
                     .set(.text(Text.title.enter))
               } setDown: {
                  $0
                     .set(.text(Text.title.enterTelegramName))
                     .set(.alignment(.left))
               },
            Spacer(36),
         ]))

      mainViewModel.bottomStackModel
         .set(Design.state.stack.bottomPanel)

         .set(.models([
            loginTextField,
            nextButton,
            Spacer(),
         ]))
   }
}
