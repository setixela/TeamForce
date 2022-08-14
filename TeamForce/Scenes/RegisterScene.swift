//
//  RegisterScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import ReactiveWorks

// MARK: - RegisterScene

final class RegisterScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Void
> {
   //
   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.register))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("1. " + Text.title.enterTelegramName))
      .set(.numberOfLines(2))

   private lazy var nextButton = ButtonModel(Design.state.button.inactive)
      .set(.title(Text.button.nextButton))

   private lazy var textFieldModel = TextFieldModel<Design>()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder("@" + Text.title.userName))

   private lazy var inputParser = TelegramNickCheckerModel()

   // MARK: - Start

   override func start() {

      setupLoginField()
      configure()

      nextButton
         .onEvent(\.didTap) {
            print("Did tap")
         }
   }

   private func setupLoginField() {
//      textFieldModel
//         .onEvent(\.didEditingChanged) { [weak self] text in
//            self?.inputParser.sendEvent(\.request, text)
//         }
//
//      inputParser
//         .onEvent(\.success) { [weak self] text in
//            self?.textFieldModel.set(.text(text))
//            self?.nextButton.set(Design.state.button.default)
//         }
//         .onEvent(\.error) { [weak self] text in
//            self?.textFieldModel.set(.text(text))
//            self?.nextButton.set(Design.state.button.inactive)
//         }
   }

   private func configure() {
      mainVM
         .set(Design.state.stack.default)
         .set(.backColor(Design.color.backgroundSecondary))

      mainVM.topStackModel
         .set(.models([
            Spacer(100),
            headerModel,
            subtitleModel,
            Spacer(16),
            textFieldModel,
            Spacer()
         ]))

      mainVM.bottomStackModel
         .set(.models([
            nextButton
         ]))
   }
}
