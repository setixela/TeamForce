//
//  LoginScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - LoginScene

final class LoginScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   StackWithBottomPanelModel,
   Asset,
   Void
> {
   //
   
   private lazy var clapHandsImage = ImageViewModel()
      .set(.size(.init(width: 242, height: 290)))
      .set(.image(Icons().make(\.clapHands)))
      .set(.contentMode(.scaleAspectFit))
   
   private lazy var headerModel = Design.label.headline4
      .set(.padding(.init(top: 0, left: 0, bottom: 24, right: 0)))
      .set(.text("Вход"))

   private lazy var subtitleModel = Design.label.subtitle
      .set(.padding(.init(top: 0, left: 0, bottom: 40, right: 0)))
      .set(.text("1. " + text.title.make(\.pressGetCode)))
      .set(.numberOfLines(2))

   private lazy var nextButton = Design.button.inactive
      .set(.title(text.button.make(\.nextButton)))

   private lazy var changeUserButton = Design.button.transparent
      .set(.title(text.button.make(\.changeUserButton)))

   private lazy var textFieldModel = TextFieldModel()
      .set(.padding(.init(top: 16, left: 16, bottom: 16, right: 16)))
      .set(.placeholder("@" + text.title.make(\.userName)))
      .set(.backColor(UIColor.clear))
      .set(.borderColor(.lightGray.withAlphaComponent(0.4)))
      .set(.borderWidth(1.0))
   
   private lazy var inputParser = TelegramNickCheckerModel()
   private lazy var apiModel = AuthApiModel(apiEngine: Asset.service.apiEngine)

   private var loginName: String?

   // MARK: - Start

   override func start() {
//      mainViewModel.set(Design.State.mainView.default)
      
      weak var weakSelf = self

      vcModel?
         .onEvent(\.viewDidLoad) {
            weakSelf?.configure()
         }
      
      nextButton
         .onEvent(\.didTap) {
            guard let loginName = weakSelf?.loginName else { return }

            weakSelf?.apiModel
               .onEvent(\.success) { authResult in
                  Asset.router?.route(\.verifyCode, navType: .push, payload: authResult)
               }
               .onEvent(\.error) { error in
                  print("\n", error.localizedDescription)
               }
               .sendEvent(\.request, loginName)
         }

      textFieldModel
         .onEvent(\.didEditingChanged) { text in
            weakSelf?.inputParser.sendEvent(\.request, text)
         }

      inputParser
         .onEvent(\.success) { text in
            weakSelf?.loginName = String(text.dropFirst())
            weakSelf?.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.State.button.default)
         }
         .onEvent(\.error) { text in
            weakSelf?.loginName = nil
            weakSelf?.textFieldModel.set(.text(text))
            weakSelf?.nextButton.set(Design.State.button.inactive)
         }
   }

   private func configure() {
      mainViewModel.setupBackgroundImage(name: "background_vector.png")
      
      mainViewModel
         .set(Design.State.mainView.default)
         .set(.backColor(Design.color.background2))
      mainViewModel.topStackModel
         .set(.models([
            Spacer(size: 50),
            clapHandsImage,
            headerModel,
            subtitleModel,
            Spacer(size: 16),
            textFieldModel,
            Spacer()
         ]))
      
      mainViewModel.bottomStackModel
         .set(.models([
            nextButton,
            changeUserButton
         ]))
         
   }
}
