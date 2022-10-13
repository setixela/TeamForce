//
//  ChallengeCreateScene.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 11.10.2022.
//

import ReactiveWorks
import UIKit

struct ChallengeCreateEvents: InitProtocol {
   var cancelled: Void?
   var continueButtonPressed: Void?
   var finishWithSuccess: Void?
   var finishWithError: Void?
}

final class ChallengeCreateScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   ModalDoubleStackModel<Asset>,
   Asset,
   Void
>, Scenarible {
   typealias State = StackState

   private lazy var works = ChallengeCreateWorks<Asset>()

   lazy var scenario: Scenario = ChallengeCreateScenario(
      works: works,
      stateDelegate: setState,
      events: ChallengeCreateScenarioEvents()
   )

   private lazy var viewModels = ChallengeCreateViewModel<Design>()

   private lazy var activityIndicator = Design.model.common.activityIndicator
   private lazy var imagePicker = Design.model.common.imagePicker

   private var currentState = ChallengeCreateSceneState.initial

   // MARK: - Start

   override func start() {
      super.start()

      scenario.start()

      mainVM.closeButton.on(\.didTap, self) {
         $0.vcModel?.dismiss(animated: true)
      }
   }
}

enum ChallengeCreateSceneState {
   case initial

   case presentImagePicker
   case presentPickedImage(UIImage)
   case setHideAddPhotoButton(Bool)

   case continueButtonPressed
   case cancelButtonPressed
}

extension ChallengeCreateScene: StateMachine {
   func setState(_ state: ChallengeCreateSceneState) {}
}
