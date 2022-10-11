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
         info.text("415 форсиков")
      }

   private lazy var finishDateCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, info in
         icon.image(Design.icon.tablerClock)
         title.text("Дата завершения")
         info.text("415 форсиков")
      }

   private lazy var prizePlacesCell = ChallengeDetailsInfoCell<Design>()
      .setAll { icon, title, _, info in
         icon.image(Design.icon.tablerGift)
         title.text("Призовых мест")
         info.text("415 форсиков")
      }

   override func start() {
      super.start()

      arrangedModels([
         // challengeInfo,
         prizeSizeCell,
         finishDateCell,
         prizePlacesCell,
         Spacer()
      ])
      .spacing(8)
      .padding(.horizontalOffset(16))
   }
}

enum ChallengeDetailsViewModelState {
   case details(Challenge)
}

extension ChallengeDetailsViewModel: StateMachine {
   func setState(_ state: ChallengeDetailsViewModelState) {
      switch state {
      case .details(let challenge):
         challengeInfo.setup(challenge)
         prizeSizeCell.models.right3.text(challenge.prizeSize.toString + " " + "форсиков")
         let dateStr = challenge.endAt.string.convertToDate(.full).string
         finishDateCell.models.right3.text(dateStr)
         prizePlacesCell.models.right3.text(challenge.winnersCount.int.toString
                                            + " / " + challenge.awardees.toString)
      }
   }
}

extension ChallengeDetailsViewModel: SetupProtocol {
   func setup(_ data: Challenge) {
      challengeInfo.setup(data)
   }
}

final class ChallengeInfoVM<Design: DSP>: StackModel, Designable {
   lazy var title = Design.label.title
   lazy var body = Design.label.body1
   lazy var tags = StackModel()

   override func start() {
      super.start()
   }
}

extension ChallengeInfoVM: SetupProtocol {
   func setup(_ data: Challenge) {
      title.text(data.name.string)
      body.text(data.description.string)
      tags.arrangedModels([
         ChallengeStatusBlock<Design>()
            .text("JDSAH askjdha skj"),
         ChallengeStatusBlock<Design>()
            .text("JDSAH askjdha skj")
      ])
   }
}

final class ChallengeStatusBlock<Design: DSP>: LabelModel, Designable {
   override func start() {
      backColor(Design.color.backgroundInfoSecondary)
      height(36)
      cornerRadius(36 / 2)
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
