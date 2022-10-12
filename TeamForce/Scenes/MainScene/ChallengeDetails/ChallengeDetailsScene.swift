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
   QuadroStacksModel,
   Asset,
   Challenge
>, Scenarible {
   //
   lazy var scenario: Scenario = ChallengeDetailsScenario(
      works: ChallengeDetailsWorks<Asset>(),
      stateDelegate: setState,
      events: ChallengeDetailsInputEvents(
         saveInputAndLoadChallenge: on(\.input)
         // getContenders: ,
         // getWinners: ,
      )
   )

   private lazy var headerImage = ImageViewModel()
      .image(Design.icon.challengeWinnerIllustrate)
      // .padding(.verticalOffset(16))
      .contentMode(.scaleAspectFit)

   private lazy var filterButtons = SlidedIndexButtons<Button3Event>(buttons:
      SecondaryButtonDT<Design>()
         .title("Детали")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Комментарии")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Участники")
         .font(Design.font.default))

   private lazy var viewModel = ChallengeDetailsViewModel<Design>()

   private lazy var sendPanel = SendChallengePanel<Design>()

   override func start() {
      super.start()

      mainVM.headerStack
         .backColor(Design.color.backgroundBrandSecondary)
         .height(200)
         .arrangedModels([
            headerImage
         ])

      mainVM.bodyStack
         .padding(.init(
            top: 24,
            left: Design.params.commonSideOffset,
            bottom: 16,
            right: Design.params.commonSideOffset
         ))
         .arrangedModels([
            filterButtons
         ])

      mainVM.captionStack
         .padding(.init(
            top: 0,
            left: Design.params.commonSideOffset,
            bottom: 0,
            right: Design.params.commonSideOffset
         ))
         .arrangedModels([
            viewModel
         ])

      mainVM.footerStack
         .padding(.init(
            top: 16,
            left: Design.params.commonSideOffset,
            bottom: 16,
            right: Design.params.commonSideOffset
         ))
         .arrangedModels([
            sendPanel
         ])

      scenario.start()

      viewModel.on(\.willEndDragging) { [weak self] velocity in
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
}

extension ChallengeDetailsScene: StateMachine {
   func setState(_ state: ChallengeDetailsState) {
      switch state {
      case .initial:
         break
      case .presentChallenge(let challenge):
         if let url = challenge.photo {
            headerImage
               .url(TeamForceEndpoints.urlBase + url)
               // .padding(.verticalOffset(0))
               .contentMode(.scaleAspectFill)
         }
         sendPanel.setup(challenge)
         viewModel.setState(.presentChallenge(challenge))
      case .updateDetails(let challenge):
         sendPanel.setup(challenge)
         viewModel.setState(.updateDetails(challenge))
      }
   }
}

// MARK: - Header animation

extension ChallengeDetailsScene {
   private func presentHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.headerStack
            .hidden(false)
            .alpha(1)
      }
   }

   private func hideHeader() {
      UIView.animate(withDuration: 0.36) {
         self.mainVM.headerStack
            .alpha(0)
            .hidden(true)
      }
   }
}
