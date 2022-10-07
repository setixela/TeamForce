//
//  ChallengesViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import ReactiveWorks

final class ChallengesViewModel<Design: DSP>: StackModel, Designable {
   //
   private lazy var createChallengeButton = ButtonModel()
      .set(Design.state.button.default)
      .title("Создать челлендж")

   private lazy var filterButtons = ChallengesFilterButtons<Design>()

   private lazy var challengesTable = TableItemsModel<Design>()
      .set(.presenters([ChallengeCellPresenters<Design>().presenter]))

   override func start() {
      super.start()

      arrangedModels([
         createChallengeButton,
         Grid.x16.spacer,
         filterButtons,
         Grid.x16.spacer,
         challengesTable,
         Grid.xxx.spacer,
      ])
   }
}

enum ChallengesViewModelState {
   case presentChallenges([Challenge])
}

extension ChallengesViewModel: StateMachine {
   func setState(_ state: ChallengesViewModelState) {
      switch state {
      case .presentChallenges(let challenges):
         challengesTable.set(.items(challenges))
      }
   }
}

final class ChallengesFilterButtons<Design: DSP>: StackModel, Designable, Eventable {
   struct Events: InitProtocol {
      var didTapAll: Void?
      var didTapActive: Void?
   }

   var events = [Int: LambdaProtocol?]()

   lazy var buttonAll = SecondaryButtonDT<Design>()
      .title("Все")
      .font(Design.font.default)
      .on(\.didTap, self) {
         $0.select(0)
         $0.send(\.didTapAll)
      }

   lazy var buttonActive = SecondaryButtonDT<Design>()
      .title("Активные")
      .font(Design.font.default)
      .on(\.didTap, self) {
         $0.select(1)
         $0.send(\.didTapActive)
      }

   override func start() {
      axis(.horizontal)
      spacing(Grid.x8.value)
      padBottom(8)
      arrangedModels([
         buttonAll,
         buttonActive,
         Grid.xxx.spacer,
      ])
      select(0)
   }

   private func deselectAll() {
      buttonAll.setMode(\.normal)
      buttonActive.setMode(\.normal)
   }

   private func select(_ index: Int) {
      deselectAll()
      switch index {
      case 0:
         buttonAll.setMode(\.selected)
      default:
         buttonActive.setMode(\.selected)
      }
   }
}

final class ChallengeCell<Design: DSP>:
   M<ChallengeCellInfoBlock>
   .R<StackModel>.Combo, Designable
{
   required init() {
      super.init()

      setAll { infoBlock, _ in
         infoBlock.setAll { title, participant, winner, prizeFund, prizes in
            title.text("Заголовок")

            participant.title.text("2131")
            participant.body.text("Участников")

            winner.title.text("2131")
            winner.body.text("Победителей")

            prizeFund.title.text("2131")
            prizeFund.body.text("Призовой фонд")

            prizes.title.text("2131")
            prizes.body.text("Призовых мест")
         }
      }
   }
}

final class ChallengeCellInfoBlock:
   M<LabelModel>
   .D<TitleBodyY>.R<TitleBodyY>
   .D2<TitleBodyY>
   .D3<TitleBodyY>
   .Combo {}

struct ChallengeCellPresenters<Design: DSP>: Designable {
   var presenter: Presenter<Challenge, ChallengeCell<Design>> { .init { work in
      let model = ChallengeCell<Design>()

      work.success(model)
   } }
}
