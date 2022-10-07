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
      .set(.presenters([
         ChallengeCellPresenters<Design>.presenter,
         SpacerPresenter.presenter,
      ]))

   override func start() {
      super.start()

      arrangedModels([
         createChallengeButton,
         Grid.x16.spacer,
         filterButtons,
         Grid.x16.spacer,
         challengesTable,
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
         challengesTable.set(.items(challenges + [Grid.x128.spacer]))
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
   .R<ChallengeCellStatusBlock<Design>>.Combo, Designable
{
   lazy var back = ImageViewModel()
      .backColor(Design.color.backgroundBrandSecondary)
      .cornerRadius(Design.params.cornerRadius)

   required init() {
      super.init(isAutoreleaseView: true)

      setAll { infoBlock, _ in
         infoBlock.setAll { title, participant, winner, prizeFund, prizes in
            title.set(Design.state.label.body4)

            participant.title.set(Design.state.label.body2)
            participant.body.set(Design.state.label.caption)

            winner.title.set(Design.state.label.body2)
            winner.body.set(Design.state.label.caption)

            prizeFund.title.set(Design.state.label.body2)
            prizeFund.body.set(Design.state.label.caption)

            prizes.title.set(Design.state.label.body2)
            prizes.body.set(Design.state.label.caption)
         }
      }
      height(208)
      padding(.init(top: 20, left: 16, bottom: 20, right: 16))
      backViewModel(back, inset: .verticalOffset(4))
   }
}

enum ChallengeCellState {
   case normal
   case inverted
}

extension ChallengeCell: StateMachine {
   func setState(_ state: ChallengeCellState) {
      switch state {
      case .normal:
         setAll { infoBlock, _ in
            infoBlock.setAll { title, participant, winner, prizeFund, prizes in
               title.textColor(Design.color.text)

               participant.title.textColor(Design.color.text)
               participant.body.textColor(Design.color.text)

               winner.title.textColor(Design.color.text)
               winner.body.textColor(Design.color.text)

               prizeFund.title.textColor(Design.color.text)
               prizeFund.body.textColor(Design.color.text)

               prizes.title.textColor(Design.color.text)
               prizes.body.textColor(Design.color.text)
            }
         }
      case .inverted:
         setAll { infoBlock, _ in
            infoBlock.setAll { title, participant, winner, prizeFund, prizes in
               title.textColor(Design.color.textInvert)

               participant.title.textColor(Design.color.textInvert)
               participant.body.textColor(Design.color.textInvert)

               winner.title.textColor(Design.color.textInvert)
               winner.body.textColor(Design.color.textInvert)

               prizeFund.title.textColor(Design.color.textInvert)
               prizeFund.body.textColor(Design.color.textInvert)

               prizes.title.textColor(Design.color.textInvert)
               prizes.body.textColor(Design.color.textInvert)
            }
         }
      }
   }
}

final class ChallengeCellInfoBlock:
   M<LabelModel>
   .D<TitleBodyY>.R<TitleBodyY>
   .D2<TitleBodyY>
   .D3<TitleBodyY>
   .Combo
{
   override func start() {
      super.start()

      spacing(12)
   }
}

final class ChallengeCellStatusBlock<Design: DSP>: StackModel, Designable {

   lazy var statusLabel = LabelModel()
      .set(Design.state.label.caption)
      .cornerRadius(Design.params.cornerRadiusMini)
      .height(Design.params.buttonHeightMini)
      .backColor(Design.color.background)
      .padding(.verticalOffset(8))

   override func start() {
      super.start()

      arrangedModels([
         statusLabel,
         Grid.xxx.spacer
      ])
   }
}

struct ChallengeCellPresenters<Design: DSP>: Designable {
   static var presenter: Presenter<Challenge, ChallengeCell<Design>> { .init { work in
      let data = work.unsafeInput

      let model = ChallengeCell<Design>()
         .setAll { infoBlock, statusBlock in
            infoBlock.setAll { title, participant, winner, prizeFund, prizes in
               title.text("Заголовок")

               participant.title.text(data.approvedReportsAmount.toString)
               participant.body.text("Участников")

               winner.title.text(data.awardees.toString)
               winner.body.text("Победителей")

               prizeFund.title.text(data.fund.toString)
               prizeFund.body.text("Призовой фонд")

               prizes.title.text(data.prizeSize.toString)
               prizes.body.text("Призовых мест")
            }

            statusBlock.statusLabel
               .text("Активен")
         }

      if let suffix = data.photo {
         model.setState(.inverted)
         model.back
            .backColor(Design.color.iconContrast)
            .url(TeamForceEndpoints.urlBase + suffix)
            .addModel(
               ViewModel()
                  .backColor(Design.color.iconContrast)
                  .alpha(0.6)
            ) { anchors, view in
               anchors.fitToView(view)
            }
      }

      work.success(model)
   } }
}
