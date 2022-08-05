//
//  RegisterScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit
import ReactiveWorks

// MARK: - RegisterScene

final class RegisterScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   Void
> {
   //
   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text(Text.title.make(\.register)))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("1. " + Text.title.make(\.enterTelegramName)))
      .set(.numberOfLines(2))

   private lazy var nextButton = ButtonModel(Design.State.button.inactive)
      .set(.title(Text.button.make(\.nextButton)))

   private lazy var textFieldModel = TextFieldModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder("@" + Text.title.make(\.userName)))

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
//            self?.nextButton.set(Design.State.button.default)
//         }
//         .onEvent(\.error) { [weak self] text in
//            self?.textFieldModel.set(.text(text))
//            self?.nextButton.set(Design.State.button.inactive)
//         }
   }

   private func configure() {
      mainViewModel
         .set(Design.State.mainView.default)
         .set(.backColor(Design.color.background2))

      mainViewModel.topStackModel
         .set(.models([
            Spacer(size: 100),
            headerModel,
            subtitleModel,
            Spacer(size: 16),
            textFieldModel,
            Spacer()
         ]))

      mainViewModel.bottomStackModel
         .set(.models([
            nextButton
         ]))
   }
}
