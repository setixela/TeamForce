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

   case resultSent
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
         commentInputChanged: inputView.on(\.didEditingChanged),
         sendResult: sendButton.on(\.didTap)
      )
   )

   lazy var scenario2: Scenario = ImagePickingScenario<Asset>(
      works: works,
      stateDelegate: stateDelegate2,
      events: ImagePickingScenarioEvents(
         startImagePicking: addPhotoButton.on(\.didTap),
         addImageToBasket: imagePicker.onEvent(\.didImagePicked),
         removeImageFromBasket: photosPanel.on(\.didCloseImage),
         didMaximumReach: photosPanel.on(\.didMaximumReached)
      )
   )

   private lazy var inputView = Design.model.transact.reasonInputTextView
      .placeholder(Design.Text.title.comment)
      .minHeight(166)

   private lazy var photosPanel = Design.model.transact.pickedImagesPanel
   private lazy var addPhotoButton = Design.model.transact.addPhotoButton
   private lazy var sendButton = Design.model.transact.sendButton

   private lazy var imagePicker = Design.model.common.imagePicker

   override func start() {
      super.start()

      mainVM.title
         .text("Результат")

      mainVM.bodyStack
         .spacing(Grid.x16.value)
         .arrangedModels([
            inputView,
            photosPanel.lefted(),
            addPhotoButton,
            Spacer()
         ])
      mainVM.footerStack
         .arrangedModels([
            Grid.x16.spacer,
            sendButton
         ])

      mainVM.closeButton
         .on(\.didTap, self) {
            $0.vcModel?.dismiss(animated: true)
         }

      scenario.start()
      scenario2.start()
   }
}

extension ChallengeResultScene {
   func setState(_ state: ChallengeResultSceneState) {
      switch state {
      case .initial:
         break
      case .sendingEnabled:
         sendButton.set(Design.state.button.default)
      case .sendingDisabled:
         sendButton.set(Design.state.button.inactive)
      case .resultSent:
         vcModel?.dismiss(animated: true)
      }
   }
}

extension ChallengeResultScene: StateMachine2 {
   func setState2(_ state: ImagePickingState) {
      switch state {
         //
      case .presentPickedImage(let image):
         photosPanel.addButton(image: image)
         //
      case .presentImagePicker:
         guard let baseVC = vcModel else { return }
         imagePicker.sendEvent(\.presentOn, baseVC)
         //
      case .setHideAddPhotoButton(let value):
         addPhotoButton.hidden(value)
         //
      }
   }
}

