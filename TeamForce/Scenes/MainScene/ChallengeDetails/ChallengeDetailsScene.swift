//
//  ChallengeDetailsScene.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 09.10.2022.
//

import ReactiveWorks
import UIKit

struct ChallengeDetailsSceneInput {
   let challenge: Challenge
   let profileId: Int
   let currentButton: Int
}

final class ChallengeDetailsScene<Asset: AssetProtocol>: BaseSceneModel<
   DefaultVCModel,
   TripleStacksModel,
   Asset,
   ChallengeDetailsSceneInput
>, Scenarible {
   //
   lazy var scenario: Scenario = ChallengeDetailsScenario(
      works: ChallengeDetailsWorks<Asset>(),
      stateDelegate: stateDelegate,
      events: ChallengeDetailsInputEvents(
         saveInputAndLoadChallenge: on(\.input),
         // getContenders: ,
         // getWinners: ,
         challengeResult: challDetails.buttonsPanel.sendButton.on(\.didTap),
         filterButtonTapped: filterButtons.on(\.didTapButtons),
         acceptPressed: contendersBlock.presenter.on(\.acceptPressed),
         rejectPressed: contendersBlock.presenter.on(\.rejectPressed),
         didSelectWinnerIndex: winnersBlock.on(\.didSelectWinner),
         didEditingComment: challComments.commentField.on(\.didEditingChanged),
         didSendCommentPressed: challComments.sendButton.on(\.didTap),
         reactionPressed: challDetails.buttonsPanel.likeButton.view.on(\.didTap)
      )
   )

   private lazy var statusLabel = LabelModel()
      .set(Design.state.label.caption)
      .cornerRadius(Design.params.cornerRadiusMini)
      .height(Design.params.buttonHeightMini)
      .textColor(Design.color.textInvert)
      .padding(.horizontalOffset(8))

   private lazy var closeButton = ButtonModel()
      .title(Design.Text.title.close)
      .textColor(Design.color.textBrand)
      .height(Design.params.buttonHeightMini)

   private lazy var headerImage = ImageViewModel()
      .image(Design.icon.challengeWinnerIllustrateFull)
      .contentMode(.scaleAspectFill)
      .set(.tapGesturing)

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
         .font(Design.font.default)
         .hidden(true),
      SecondaryButtonDT<Design>()
         .title("Участники")
         .font(Design.font.default)
         .hidden(true))
      .height(16 + 38)
      .backColor(Design.color.background)

   private lazy var challDetails = ChallengeDetailsViewModel<Design>()
      .backColor(Design.color.background)

   private lazy var myResultBlock = ChallResultViewModel<Design>()
      .set(.padding(.horizontalOffset(Design.params.commonSideOffset)))
      .backColor(Design.color.background)

   private lazy var winnersBlock = ChallWinnersViewModel<Design>()
      .set(.padding(.horizontalOffset(Design.params.commonSideOffset)))
      .backColor(Design.color.background)

   private lazy var contendersBlock = ChallContendersViewModel<Design>()
      .set(.padding(.horizontalOffset(Design.params.commonSideOffset)))
      .backColor(Design.color.background)

   private lazy var challComments = FeedCommentsBlock<Design>()
      .set(.padding(.horizontalOffset(Design.params.commonSideOffset)))
      .backColor(Design.color.background)

   override func start() {
      super.start()

      setState(.presentActivityIndicator)
      vcModel?.on(\.viewDidLoad, self) {
         $0.configure()
      }

      closeButton.on(\.didTap, self) {
         $0.dismiss()
      }
   }

   private func configure() {
      mainVM.headerStack
         .backColor(Design.color.backgroundBrandSecondary)
         .arrangedModels([
            Wrapped3X(statusLabel, Spacer(), closeButton)
               .backViewModel(headerImage)
               .height(200)
               .alignment(.top)
               .padding(.init(top: 16, left: 16, bottom: 16, right: 16))
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

   case presentActivityIndicator
   case hereIsEmpty

   case setHeaderImage(UIImage?)

   case presentChallenge(Challenge)
   case updateDetails(Challenge)

   case presentComments([Comment])

   case presentSendResultScreen(Challenge, Int)
   case enableMyResult([ChallengeResult])
   case enableContenders

   case sendFilterButtonEvent(Int)
   case presentMyResults([ChallengeResult])
   case presentWinners([ChallengeWinnerReport])
   case presentContenders([Contender])
   case presentCancelView(Challenge, Int, Int)
   case presentReportDetailView(Challenge, Int, Int)

   case disableSendResult

   case sendButtonDisabled
   case sendButtonEnabled
   case commentDidSend
   
   case buttonLikePressed(alreadySelected: Bool)
   case failedToReact(alreadySelected: Bool)
   case updateLikesAmount(Int)
}

extension ChallengeDetailsScene: StateMachine {
   func setState(_ state: ChallengeDetailsState) {
      switch state {
      case .initial:
         break
      case .presentActivityIndicator:
         mainVM.footerStack
            .arrangedModels([
               ActivityIndicator<Design>(),
               Spacer()
            ])
      case .presentChallenge(let challenge):
         updateHeaderImage(url: challenge.photo)
         mainVM.footerStack
            .arrangedModels([
               challDetails
            ])
         challDetails.setState(.presentChallenge(challenge))
         filterButtons.button4.hidden(false)
         filterButtons.button5.hidden(false)
         let isActive = challenge.active.bool
         statusLabel
            .text(isActive ? "Активен" : "Завершен")
            .backColor(isActive ? Design.color.backgroundInfo : Design.color.backgroundSuccess)
      case .updateDetails(let challenge):
         challDetails.setState(.updateDetails(challenge))
         updateHeaderImage(url: challenge.photo)
      case .presentComments(let comments):
         challComments.setup(comments)
         mainVM.footerStack
            .arrangedModels([
               challComments
            ])
      case .presentSendResultScreen(let challenge, let profileId):
         vcModel?.dismiss(animated: true)

         Asset.router?.route(
            .presentModally(.automatic),
            scene: \.challengeSendResult,
            payload: challenge.id
         ) { success in

            switch success {
            case true:
               Asset.router?.route(
                  .presentModally(.automatic),
                  scene: \.challengeDetails,
                  payload: ChallengeDetailsSceneInput(
                     challenge: challenge,
                     profileId: profileId,
                     currentButton: 0
                  )
               )
            case false:
               print("failure")
            }
         }
      case .enableMyResult(_):
         filterButtons.button2.hidden(false)

      case .enableContenders:
         filterButtons.button3.hidden(false)
         challDetails.models.down.sendButton.hidden(true)
         // challDetails.models.down.hidden(true)

      case .presentMyResults(let results):
         myResultBlock.setup(results)
         mainVM.footerStack
            .arrangedModels([
               myResultBlock
            ])

      case .presentWinners(let winners):
         winnersBlock.setup(winners)
         mainVM.footerStack
            .arrangedModels([
               winnersBlock
            ])

      case .presentContenders(let contenders):
         contendersBlock.setup(contenders)
         mainVM.footerStack
            .arrangedModels([
               contendersBlock
            ])
      case .presentCancelView(let challenge, let profileId, let resultId):
         vcModel?.dismiss(animated: true)

         Asset.router?.route(
            .presentModally(.automatic),
            scene: \.challengeResCancel,
            payload: resultId
         ) { success in
            switch success {
            case true:
               Asset.router?.route(
                  .presentModally(.automatic),
                  scene: \.challengeDetails,
                  payload: ChallengeDetailsSceneInput(
                     challenge: challenge,
                     profileId: profileId,
                     currentButton: 2
                  )
               )
            case false:
               break
            }
         }

      case .presentReportDetailView(let challenge, let profileId, let reportId):
         vcModel?.dismiss(animated: true)

         Asset.router?.route(
            .presentModally(.automatic),
            scene: \.challengeReportDetail,
            payload: reportId
         ) { success in
            switch success {
            case true:
               Asset.router?.route(
                  .presentModally(.automatic),
                  scene: \.challengeDetails,
                  payload: ChallengeDetailsSceneInput(
                     challenge: challenge,
                     profileId: profileId,
                     currentButton: 3
                  )
               )
            case false:
               break
            }
         }

      case .sendButtonDisabled:
         challComments.setState(.sendButtonDisabled)
      case .sendButtonEnabled:
         challComments.setState(.sendButtonEnabled)
      case .commentDidSend:
         filterButtons.button5.send(\.didTap)
         challComments.commentField.text("")
         challComments.setState(.sendButtonDisabled)

      case .disableSendResult:
         challDetails.models.down.sendButton.hidden(true)
      case .hereIsEmpty:
         mainVM.footerStack
            .arrangedModels([
               HereIsEmptySpacedBlock<Design>()
            ])
      case .sendFilterButtonEvent(let value):
         filterButtons.buttons[value].send(\.didTap)
      case .setHeaderImage(let image):
         if let image {
            headerImage.image(image)
         }
         
      case .buttonLikePressed(let selected):
         if selected {
            challDetails.buttonsPanel.likeButton.setState(.none)
         } else {
            challDetails.buttonsPanel.likeButton.setState(.selected)
         }
      case .failedToReact(let selected):
         print("failed to like")
         setState(.buttonLikePressed(alreadySelected: !selected))
      case .updateLikesAmount(let amount):
         challDetails.buttonsPanel.likeButton.models.right.text(String(amount))
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

   private func updateHeaderImage(url: String?) {
      guard
         let url,
         let inputValue
      else { return }

      let fullUrl = TeamForceEndpoints.convertToFullImageUrl(url)

      headerImage
         .url(
            TeamForceEndpoints.urlBase + url,
            transition: .crossDissolve(0.5)
         ) { header, _ in
            header?.url(
               fullUrl,
               transition: .crossDissolve(0.5)
            )
         }
         .contentMode(.scaleAspectFill)
         .on(\.didTap, self) {
            $0.dismiss()
            Asset.router?.route(
               .presentModally(.automatic),
               scene: \.imageViewer,
               payload: fullUrl
            ) { _ in
               Asset.router?.route(
                  .presentModally(.automatic),
                  scene: \.challengeDetails,
                  payload: inputValue
               )
            }
         }
   }
}
