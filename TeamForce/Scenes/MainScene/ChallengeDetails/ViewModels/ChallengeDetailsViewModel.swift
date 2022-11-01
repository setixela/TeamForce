//
//  ChallengeDetailsViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

final class ChallengeDetailsViewModel<Design: DSP>:
   M<ScrollViewModelY>
   .D<SendChallengePanel<Design>>.Combo,
   Designable
{
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

//   private lazy var activity = ActivityIndicator<Design>()

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
   }
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
//         activity.hidden(true)
         setState(.presentChallenge(challenge))
      }
   }
}

extension ChallengeDetailsViewModel: SetupProtocol {
   func setup(_ data: Challenge) {
      challengeInfo.setup(data)
   }
}

final class ChallengeInfoVM<Design: DSP>: StackModel, Designable {
   lazy var title = Design.label.headline6
      .numberOfLines(0)
   lazy var body = Design.label.default
      .numberOfLines(0)
      .lineSpacing(8)
   lazy var tags = StackModel()
      .spacing(8)

   override func start() {
      super.start()

      arrangedModels([
         title,
         Spacer(12),
         body,
         Spacer(12),
         tags
      ])
      backColor(Design.color.background)
      distribution(.equalSpacing)
      alignment(.leading)
      padding(.outline(16))
      cornerRadius(Design.params.cornerRadiusSmall)
      shadow(Design.params.cellShadow)
   }
}

extension ChallengeInfoVM: SetupProtocol {
   func setup(_ data: Challenge) {
      title.text(data.name.string)
      body.text(data.description.string)
      let arrayOfStates = data.status?.components(separatedBy: ", ")
      let states = arrayOfStates?.map { ChallengeStatusBlock<Design>().text($0) }
      tags.arrangedModels(states ?? [])
   }
}

final class ChallengeStatusBlock<Design: DSP>: LabelModel, Designable {
   override func start() {
      font(Design.font.caption)
      backColor(Design.color.backgroundInfoSecondary)
      height(36)
      cornerRadius(36 / 2)
      padding(.horizontalOffset(12))
      textColor(Design.color.textInfo)
   }
}

final class ChallengeDetailsInfoCell<Design: DSP>:
   M<ImageViewModel>.R<LabelModel>.R2<Spacer>.R3<LabelModel>.Combo,
   Designable
{
   required init() {
      super.init()

      setAll { icon, title, _, status in
         icon.size(.square(24))
         title.set(Design.state.label.default)
         status.set(Design.state.label.captionSecondary)
      }
      .backColor(Design.color.background)
      .height(Design.params.buttonHeight)
      .cornerRadius(Design.params.cornerRadiusSmall)
      .shadow(Design.params.cellShadow)
      .spacing(12)
      .alignment(.center)
      .padding(.horizontalOffset(16))
   }
}

final class SendChallengePanel<Design: DSP>: StackModel, Designable {
//    var events: EventsStore = .init()
   
   var sendButton: ButtonModel { buttons.models.main }
   var likeButton: ReactionButton<Design> { buttons.models.right }

   // Private

//   private lazy var userPanel = Design.model.profile.userPanel

   private lazy var buttons = M<ButtonModel>.R<ReactionButton<Design>>.Combo()
      .setAll { sendButton, likeButton in
         sendButton
            .set(Design.state.button.default)
            .font(Design.font.body1)
            .title("Отправить результат")
            .hidden(true)
//         dislikeButton
//            .set(Design.state.button.secondary)
//            .image(Design.icon.dislike)
//            .width(68)
//            .backColor(Design.color.backgroundInfoSecondary)
//            .title("13")
//            .hidden(true)
         likeButton
            .setAll {
               $0.image(Design.icon.like)
               $1
                  .font(Design.font.caption)
                  .text("0")
            }
            .removeAllConstraints()
            .width(68)
      }
      .spacing(8)

   override func start() {
      super.start()
      likeButton.view.startTapGestureRecognize()
      
      arrangedModels([
         Grid.x16.spacer,
         buttons
      ])
   }
}
