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
   TripleStacksModel,
   Asset,
   (Challenge, Int)
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
      .height(200)

   private lazy var filterButtons = SlidedIndexButtons<Button6Event>(buttons:
      SecondaryButtonDT<Design>()
         .title("Детали")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Мой результат")
         .font(Design.font.default)
         .hidden(true),
      SecondaryButtonDT<Design>()
         .title("Кандидаты")
         .font(Design.font.default)
         .hidden(true),
      SecondaryButtonDT<Design>()
         .title("Победители")
         .font(Design.font.default)
         .hidden(true),
      SecondaryButtonDT<Design>()
         .title("Комментарии")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Участники")
         .font(Design.font.default))
      .height(16 + 38)
      .backColor(Design.color.background)

   private lazy var challDetails = ChallengeDetailsViewModel<Design>()
      .set(.padding(.horizontalOffset(Design.params.commonSideOffset)))
      .backColor(Design.color.background)

   private lazy var challComments = FeedCommentsBlock<Design>()

   override func start() {
      super.start()

      mainVM.headerStack
         .backColor(Design.color.backgroundBrandSecondary)
         // .height(200)
         .arrangedModels([
            headerImage

         ])

      mainVM.bodyStack
         .arrangedModels([
            filterButtons
         ])
         .padding(.horizontalOffset(Design.params.commonSideOffset))
         .padTop(8)
         .backColor(Design.color.background)

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

   case presentSendResultScreen(Challenge,Int)
   case enableMyResult([ChallengeResult])
   case enableContenders
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
      case .presentSendResultScreen(let challenge, let challengeId):

         vcModel?.dismiss(animated: false)

         Asset.router?.route(
            \.challengeSendResult,
            navType: .presentModally(.automatic),
            payload: challengeId
         )
         .onSuccess {
            Asset.router?.route(
               \.challengeDetails,
               navType: .presentModally(.automatic),
               payload: (challenge, challengeId)
            )
         }
         .onFail {
            print("failure")
         }
         .retainBy(retainer)

      case .enableMyResult(let value):
         print("value \(value)")
         filterButtons.buttons[1].hidden(false)

      case .enableContenders:
         filterButtons.buttons[2].hidden(false)
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
