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
      .set(.text(Text.title.make(\.enter)))

   private let subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 32, right: 0)))
      .set(.text(Text.title.make(\.enterTelegramName)))
      .set(.numberOfLines(2))

   private let nextButton = Design.button.inactive
      .set(.title(Text.button.make(\.getCodeButton)))

   private let badgeModel = BadgeModel<Asset>()

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
         .setLabels(title: Text.title.make(\.userName),
                    placeholder: "@" + Text.title.make(\.userName),
                    error: Text.title.make(\.wrongUsername))

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
            loginName = String(text.dropFirst())
            weakSelf?.badgeModel.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.State.button.default)
         }
         .onFail { (text: String) in
            loginName = nil
            weakSelf?.badgeModel.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.State.button.inactive)
         }
   }

   private func configure() {
      mainViewModel
         .set(.backColor(Design.color.background2))

      mainViewModel.topStackModel
         .set(.models([
            Spacer(48),
            coverViewModel
         ]))

      mainViewModel.bottomStackModel
         .set(Design.State.mainView.default)
         .set(.models([
            headerModel,
            subtitleModel,
            badgeModel,
            Spacer(),
            nextButton
         ]))
   }
}
