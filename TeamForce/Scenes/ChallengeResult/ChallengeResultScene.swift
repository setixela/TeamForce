//
//  ChallengeResultScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.10.2022.
//

import ReactiveWorks

enum ChallengeResultSceneState {
   case initial

   case sendingEnabled
   case sendingDisabled

   case popScene
   case resultSent
   
   case finish
}

final class ChallengeResultScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ModalDoubleStackModel<Asset>,
   Asset,
   Int
>, Scenarible2 {
//
   private let works = ChallengeResultWorks<Asset>()

   lazy var scenario: Scenario = ChallengeResultScenario<Asset>(
      works: works,
      stateDelegate: stateDelegate,
      events: ChallengeResultEvents(
         saveInput: on(\.input),
         commentInputChanged: inputModel.on(\.didEditingChanged),
         sendResult: sendButton.on(\.didTap)
      )
   )

   lazy var scenario2: Scenario = ImagePickingScenario<Asset>(
      works: works,
      stateDelegate: stateDelegate2,
      events: ImagePickingScenarioEvents(
         startImagePicking: addPhotoButton.on(\.didTap),
         addImageToBasket: imagePicker.on(\.didImagePicked),
         removeImageFromBasket: photosPanel.subModel.on(\.didCloseImage),
         didMaximumReach: photosPanel.subModel.on(\.didMaximumReached)
      )
   )

   private lazy var inputModel = Design.model.transact.reasonInputTextView
      .placeholder(Design.Text.title.comment)
      .height(166)

   private lazy var photosPanel = Design.model.transact.pickedImagesPanel
      .lefted()
      .hidden(true)

   private lazy var addPhotoButton = Design.model.transact.addPhotoButton
   private lazy var sendButton = Design.model.transact.sendButton

   private lazy var imagePicker = Design.model.common.imagePicker

   override func start() {
      super.start()

      mainVM.title
         .text("Результат")

      mainVM.bodyStack
         .spacing(Grid.x16.value)
         .arrangedModels(ActivityIndicator<Design>())

      vcModel?.on(\.viewDidLoad, self) { $0.configure() }
   }

   private func configure() {
      setState(.initial)

      mainVM.closeButton
         .on(\.didTap, self) {
            $0.dismiss()
            $0.finisher?(false)
         }

      scenario.start()
      scenario2.start()
   }
}

extension ChallengeResultScene {
   func setState(_ state: ChallengeResultSceneState) {
      switch state {
      case .initial:
         mainVM.bodyStack
            .arrangedModels(
               inputModel,
               photosPanel,
               addPhotoButton,
               Spacer()
            )
         mainVM.footerStack
            .arrangedModels(
               Grid.x16.spacer,
               sendButton
            )
         mainVM.view.setNeedsLayout()
      case .sendingEnabled:
         sendButton.set(Design.state.button.default)
      case .sendingDisabled:
         sendButton.set(Design.state.button.inactive)
      case .popScene:
         vcModel?.dismiss(animated: true)
      case .resultSent:
         finisher?(true)
      case .finish:
         vcModel?.dismiss(animated: true)
         finisher?(true)
      }
   }
}

extension ChallengeResultScene: StateMachine2 {
   func setState2(_ state: ImagePickingState) {
      switch state {
         //
      case .presentPickedImage(let image):
         photosPanel.subModel.addButton(image: image)
         //
      case .presentImagePicker:
         imagePicker.send(\.presentOn, vcModel)
         //
      case .setHideAddPhotoButton(let value):
         photosPanel.hiddenAnimated(!value, duration: 0.2)
         addPhotoButton.hiddenAnimated(value, duration: 0.2)
         //
      }
   }
}

