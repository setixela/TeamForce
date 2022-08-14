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

   private let nextButton = Design.button.inactive
      .setTitle(Text.button.getCodeButton)

   private let badgeModel = BadgeModel<Asset>()

   private let loginTextField = TextFieldModel<Design>(Design.state.textField.default)
      .setPlaceholder("")

   private lazy var bottomPanel = StackModel()
      .set(Design.state.stack.bottomPanel)
      .setCornerRadius(Design.params.cornerRadiusMedium)
      .setShadow(.init(radius: 8, color: Design.color.iconContrast, opacity: 0.33))
      .setModels([
         Grid.x16.spacer,
         badgeModel,
         loginTextField,
         nextButton,
         Spacer(),
      ])

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
               Grid.x36.spacer,
            ])
      } setDown: { bottomStack in
         bottomStack
            .setPadding(.init(top: -Grid.x16.float,
                              left: 0,
                              bottom: 0,
                              right: 0))
            .setModels([
               // обернули в еще один стек, чтобы сделать offset с тенью
               bottomPanel
            ])
      }
   }
}

import UIKit
final class Wrapper<VM: VMP>: BaseViewModel<UIStackView>,
   VMWrapper,
   Stateable
{
   typealias State = StackState

   var subModel: VM = .init()

   override func start() {
      setModels([
         subModel,
      ])
   }
}
