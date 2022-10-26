//
//  ChallengesViewModels.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 06.10.2022.
//

import Foundation
import ReactiveWorks

struct TableScenarioInput {

}

//final class TableScenarioWorks: BaseSceneWorks<<#Temp: InitProtocol & AnyObject#>, <#Asset: AssetRoot#>> {
//
//}

//final class TableScenario: BaseScenario<Any, Any, Any> {
//
//}

final class ChallengesViewModel<Design: DSP>: StackModel, Designable, Eventable {
   struct Events: InitProtocol {
      var didSelectChallenge: Int?
   }

   var events: EventsStore = .init()

//   lazy var scenario: Scenario =

   //

   lazy var challengesTable = TableItemsModel<Design>()
      .set(.presenters([
         ChallengeCellPresenters<Design>.presenter,
         SpacerPresenter.presenter,
      ]))

   override func start() {
      super.start()

      arrangedModels([
         challengesTable,
      ])

      challengesTable
         .on(\.didSelectRowInt, self) {
            $0.send(\.didSelectChallenge, $1)
         }
   }
}

enum ChallengesViewModelState {
   case presentChallenges([Challenge])
}

extension ChallengesViewModel: StateMachine {
   func setState(_ state: ChallengesViewModelState) {
      switch state {
      case .presentChallenges(let challenges):
         challengesTable.set(.items(challenges + [SpacerItem(size: 96)]))
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
            title
               .set(Design.state.label.body4)
               .numberOfLines(1)
               .lineBreakMode(.byTruncatingTail)
               .height(20)

            participant.title.set(Design.state.label.body2)
            participant.body.set(Design.state.label.caption)

            winner.title.set(Design.state.label.body2)
            winner.body.set(Design.state.label.caption)

            prizeFund.title.set(Design.state.label.body2)
            prizeFund.body.set(Design.state.label.caption)

            prizes.title.set(Design.state.label.body2)
            prizes.body.set(Design.state.label.caption)
         }
         .alignment(.leading)
         .padding(.right(-70))
      }
      height(208)
      padding(.init(top: 20, left: 16, bottom: 20, right: 16))
      backViewModel(back, inset: .verticalOffset(4))
   }
}

enum ChallengeCellState {
   case inverted
}

extension ChallengeCell: StateMachine {
   func setState(_ state: ChallengeCellState) {
      switch state {
      case .inverted:
         setAll { infoBlock, statusBlock in
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

            statusBlock.backImage.hidden(true)
            statusBlock.dateLabel
               .backColor(Design.color.transparent)
               .textColor(Design.color.textInvert)
               .borderColor(Design.color.textInvert)
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
      distribution(.equalSpacing)
   }
}

final class ChallengeCellStatusBlock<Design: DSP>: StackModel, Designable {
   lazy var statusLabel = LabelModel()
      .set(Design.state.label.caption)
      .cornerRadius(Design.params.cornerRadiusMini)
      .height(Design.params.buttonHeightMini)
      .backColor(Design.color.background)
      .padding(.horizontalOffset(8))

   lazy var dateLabel = LabelModel()
      .set(Design.state.label.caption)
      .cornerRadius(Design.params.cornerRadiusMini)
      .height(Design.params.buttonHeightMini)
      .padding(.horizontalOffset(8))
      .backColor(Design.color.backgroundBrandSecondary)
      .borderColor(Design.color.iconContrast)
      .borderWidth(1)

   lazy var backImage = ImageViewModel()

   override func start() {
      super.start()

      alignment(.trailing)
      arrangedModels([
         statusLabel,
         Grid.xxx.spacer,
         dateLabel,
      ])

      backViewModel(backImage, inset: .init(top: 16, left: 16, bottom: 0, right: 0))
   }
}

protocol TableInputProtocol {
   var items: [Any] { get set }
   var presenters: [PresenterProtocol] { get }
}

struct ChallengeCellPresenters<Design: DSP>: Designable {
   static var presenter: Presenter<Challenge, ChallengeCell<Design>> { .init { work in
      var data = work.unsafeInput.item

      let model = ChallengeCell<Design>()
         .setAll { infoBlock, statusBlock in
            infoBlock.setAll { title, participant, winner, prizeFund, prizes in
               // title.text("Заголовок")
               title.text(data.name.string)

               participant.title.text(data.approvedReportsAmount.toString)
               participant.body.text("Участников")

               winner.title.text(data.awardees.toString)
               winner.body.text("Победителей")

               prizeFund.title.text(data.fund.toString)
               prizeFund.body.text("Призовой фонд")

               prizes.title.text(data.awardees.toString)
               prizes.body.text("Призовых мест")
            }

            let updatedDateString = data.updatedAt.string.convertToDate(.digits)
            statusBlock.statusLabel.text(data.active.bool ? "Активен" : "Завершен")
            statusBlock.dateLabel.text("Обновлен: " + updatedDateString.string)
            statusBlock.backImage
               .image(Design.icon.challengeWinnerIllustrate)
               .contentMode(.scaleAspectFit)
         }

      if let suffix = data.photo {
         model.setState(.inverted)
         model.back
            .backColor(Design.color.iconContrast)
            .addModel(
               ViewModel()
                  .backColor(Design.color.iconContrast)
                  .alpha(0.6)
            ) { anchors, view in
               anchors.fitToView(view)
            }
            .url(TeamForceEndpoints.urlBase + suffix) {
               data.photoCache = $1
            }
      }

      work.success(model)
   } }
}

final class CreateChallengePanel<Design: DSP>: StackModel, Designable {
   var events: EventsStore = .init()

   private lazy var filterButtons = SlidedIndexButtons<Button2Event>(buttons:
      SecondaryButtonDT<Design>()
         .title("Все")
         .font(Design.font.default),
      SecondaryButtonDT<Design>()
         .title("Активные")
         .font(Design.font.default))

   override func start() {
      super.start()

      arrangedModels([
         filterButtons,
      ])

      filterButtons.on(\.didTapButtons, self) {
         switch $1 {
         case .didTapButton1:
            $0.send(\.didTapFilterAll)
         case .didTapButton2:
            $0.send(\.didTapFilterActive)
         }
      }
   }
}

extension CreateChallengePanel: Eventable {
   struct Events: InitProtocol {
      var didTapFilterAll: Void?
      var didTapFilterActive: Void?
   }
}
