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
>, Scenarible {
//
   lazy var scenario: Scenario = ChallengeResultScenario<Asset>(
      works: ChallengeResultWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: ChallengeResultEvents(
         saveInput: on(\.input),
         commentInputChanged: inputView.on(\.didEditingChanged),
         sendResult: sendButton.on(\.didTap)
      )
   )

   private lazy var inputView = Design.model.transact.reasonInputTextView
      .placeholder(Design.Text.title.comment)
      .minHeight(166)

   private lazy var photosPanel = Design.model.transact.pickedImagesPanel.hidden(true)
   private lazy var addPhotoButton = Design.model.transact.addPhotoButton
   private lazy var sendButton = Design.model.transact.sendButton

   override func start() {
      super.start()

      mainVM.title
         .text("Результат")

      mainVM.bodyStack
         .spacing(Grid.x16.value)
         .arrangedModels([
            inputView,
            photosPanel,
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
   }
}

extension ChallengeResultScene: StateMachine {
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
