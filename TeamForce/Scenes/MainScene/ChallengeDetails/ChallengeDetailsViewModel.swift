//
//  ChallengeDetailsViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 10.10.2022.
//

import ReactiveWorks

final class ChallengeDetailsViewModel<Design: DSP>: StackModel, Designable {
   private lazy var challengeInfo = ChallengeInfoVM<Design>()

   private lazy var prizeSizeCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, info in
         icon.image(Design.icon.strangeLogo)
         title.text("Призовой фонд")
      }

   private lazy var finishDateCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, info in
         icon.image(Design.icon.tablerClock)
         title.text("Дата завершения")
      }
      .hidden(true)

   private lazy var prizePlacesCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, info in
         icon.image(Design.icon.tablerGift)
         title.text("Призовых мест")
      }
      .hidden(true)

   private lazy var activity = ActivityIndicator<Design>()

   override func start() {
      super.start()

      arrangedModels([
         challengeInfo,
         prizeSizeCell,
         finishDateCell,
         prizePlacesCell,
         activity,
         Spacer()
      ])
      .spacing(8)
      .padding(.horizontalOffset(16))
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
            .text(challenge.prizeSize.toString + " " + "форсиков")

         let dateStr = challenge.endAt.string.convertToDate(.full).string
         finishDateCell.models.right3
            .text(dateStr)
         finishDateCell.hidden(challenge.endAt == nil)

         prizePlacesCell.models.right3
            .text(challenge.winnersCount.int.toString + " / " + challenge.awardees.toString)
         prizePlacesCell.hidden(challenge.winnersCount == nil)

      case .updateDetails(let challenge):
         activity.hidden(true)
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
   lazy var body = Design.label.caption
   lazy var tags = StackModel()
      .spacing(8)

   override func start() {
      super.start()

      arrangedModels([
         title,
         Spacer(6),
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
      let states = data.states?.map { ChallengeStatusBlock<Design>().text($0.rawValue) }
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
