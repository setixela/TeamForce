//
//  ChallengeDetailsViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

struct ChallengeDetailsVMEvents: InitProtocol {
   var didTapUser: Void?
}

final class ChallengeDetailsViewModel<Design: DSP>:
   M<ScrollViewModelY>
   .D<SendChallengePanel<Design>>.Combo,
   Designable
{
   var events = EventsStore()

   var buttonsPanel: SendChallengePanel<Design> { models.down }

   private lazy var challengeInfo = ChallengeInfoVM<Design>()

   private lazy var prizeSizeCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, _ in
         icon.image(Design.icon.strangeLogo)
         title.text("Призовой фонд")
      }

   private lazy var finishDateCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, _ in
         icon.image(Design.icon.tablerClock)
         title.text("Дата завершения")
      }
      .hidden(true)

   private lazy var prizePlacesCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, _ in
         icon.image(Design.icon.tablerGift)
         title.text("Призовых мест")
      }
      .hidden(true)

   private lazy var userPanel = Design.model.profile.userPanel
      .shadow(Design.params.cellShadow)

   required init() {
      super.init()
      setAll { _, sendPanel in
         sendPanel
            .backColor(Design.color.background)
      }
   }

   override func start() {
      super.start()

      models.main
         .set(.spacing(8))
         .set(.bounce(true))
         .set(.arrangedModels([
            challengeInfo,
            prizeSizeCell,
            finishDateCell,
            prizePlacesCell,
            Spacer(16),
            LabelModel()
               .set(Design.state.label.captionSecondary)
               .text("Организатор"),
            userPanel
         ]))
         .set(.padding(.init(top: 4, left: 16, bottom: 16, right: 16)))

      buttonsPanel
         .padding(.horizontalOffset(Design.params.commonSideOffset))

      userPanel.view.startTapGestureRecognize()
      userPanel.view.on(\.didTap, self) {
         $0.send(\.didTapUser)
      }
   }
}

extension ChallengeDetailsViewModel: Eventable {
   typealias Events = ChallengeDetailsVMEvents
}

enum ChallengeDetailsViewModelState {
   case presentChallenge(Challenge)
   case updateDetails(Challenge)
}

extension ChallengeDetailsViewModel: StateMachine {
   func setState(_ state: ChallengeDetailsViewModelState) {
      switch state {
      case .presentChallenge(let challenge):
         challengeInfo.setup(challenge)

         prizeSizeCell.models.right3
            .text(challenge.prizeSize.toString + " " + "спасибок")

         let dateStr = challenge.endAt.string.convertToDate(.full).string
         finishDateCell.models.right3
            .text(dateStr)
         finishDateCell.hidden(challenge.endAt == nil)

         prizePlacesCell.models.right3
            .text(challenge.winnersCount.int.toString + " / " + challenge.awardees.toString)
         prizePlacesCell.hidden(challenge.winnersCount == nil)

         let creatorName = challenge.creatorName.string
         let creatorSurname = challenge.creatorSurname.string
         let creatorTgName = "@" + challenge.creatorTgName.string
         userPanel.models.right.fullName.text(creatorName + " " + creatorSurname)
         userPanel.models.right.nickName.text(creatorTgName)
         if let creatorPhoto = challenge.creatorPhoto {
            userPanel.models.main.url(TeamForceEndpoints.urlBase + creatorPhoto)
         }
         
         if let userLiked = challenge.userLiked {
            if userLiked == true {
               buttonsPanel.likeButton.setState(.selected)
            } else {
               buttonsPanel.likeButton.setState(.none)
            }
            
            let likesAmount = String(challenge.likesAmount ?? 0)
            buttonsPanel.likeButton.models.right.text(likesAmount)
         }
         
         if challenge.active == true,
            challenge.approvedReportsAmount < challenge.awardees,
            challenge.status == "Можно отправить отчёт" ||
            challenge.status == "Отчёт отклонён"
         {
            buttonsPanel.sendButton.hidden(false)
         }

      case .updateDetails(let challenge):
         setState(.presentChallenge(challenge))
      }
   }
}

extension ChallengeDetailsViewModel: SetupProtocol {
   func setup(_ data: Challenge) {
      challengeInfo.setup(data)
   }
}
