//
//  ChallengeDetailsScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.10.2022.
//

import ReactiveWorks
import UIKit

final class ChallengeDetailsScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   DoubleStacksModel,
   Asset,
   Challenge
>, Scenarible {
   //
   lazy var scenario: Scenario = ChallengeDetailsScenario(
      works: ChallengeDetailsWorks<Asset>(),
      stateDelegate: setState,
      events: ChallengeDetailsInputEvents(
         saveInputAndLoadChallenge: on(\.input),
         // getContenders: ,
         // getWinners: ,
         ChallengeResult: challDetails.buttonsPanel.sendButton.on(\.didTap)
      )
   )

   private lazy var headerImage = ImageViewModel()
      .image(Design.icon.challengeWinnerIllustrate)
      .contentMode(.scaleAspectFit)

   private lazy var challDetails = ChallengeDetailsViewModel<Design>()
      .set(.padding(.horizontalOffset(Design.params.commonSideOffset)))
      .backColor(Design.color.background)

   private lazy var challComments = FeedCommentsBlock<Design>()

   override func start() {
      super.start()

      mainVM.bodyStack
         .backColor(Design.color.backgroundBrandSecondary)
         .height(200)
         .arrangedModels([
            headerImage
         ])

      mainVM.footerStack
         .padding(.init(
            top: 16,
            left: 0,
            bottom: 16,
            right: 0
         ))
         .backColor(Design.color.background)

      scenario.start()

      challDetails.models.main.on(\.willEndDragging) { [weak self] velocity in
         if velocity < 0 {
            self?.presentHeader()
         } else if velocity > 0 {
            self?.hideHeader()
         } else {
            self?.presentHeader()
         }
      }
   }
}

enum ChallengeDetailsState {
   case initial
   case presentChallenge(Challenge)
   case updateDetails(Challenge)

   case presentComments(Challenge)

   case presentSendResultScreen(Int)
}

extension ChallengeDetailsScene: StateMachine {
   func setState(_ state: ChallengeDetailsState) {
      switch state {
      case .initial:
         break
      case .presentChallenge(let challenge):
         mainVM.footerStack
            .arrangedModels([
               challDetails
            ])

         if let url = challenge.photo {
            headerImage
               .url(TeamForceEndpoints.urlBase + url)
               .contentMode(.scaleAspectFill)
         }
         challDetails.setState(.presentChallenge(challenge))
      case .updateDetails(let challenge):
         challDetails.setState(.updateDetails(challenge))
      case .presentComments(let challenge):
         mainVM.footerStack
            .arrangedModels([
               challComments
            ])
      case .presentSendResultScreen(let challengeId):
         vcModel?.dismiss(animated: true)
         Asset.router?.route(\.challengeSendResult, navType: .presentModally(.automatic), payload: challengeId)
      }
   }
}

// MARK: - Header animation

extension ChallengeDetailsScene {
   private func presentHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.bodyStack
            .hidden(false)
            .alpha(1)
      }
   }

   private func hideHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.bodyStack
            .alpha(0)
            .hidden(true)
      }
   }
}
