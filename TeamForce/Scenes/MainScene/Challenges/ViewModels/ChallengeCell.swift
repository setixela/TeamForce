//
//  ChallengeCell.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.11.2022.
//

import Foundation

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
         infoBlock.setAll { title, winner, prizeFund, prizes in
            title.title
               .set(Design.state.label.body4)
               .numberOfLines(2)
               .lineBreakMode(.byWordWrapping)
            title.body.set(Design.state.label.caption)

            //            participant.title.set(Design.state.label.body2)
            //            participant.body.set(Design.state.label.caption)

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
      height(224)
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
            infoBlock.setAll { title, winner, prizeFund, prizes in
               title.title.textColor(Design.color.textInvert)
               title.body.textColor(Design.color.textInvert)
               //               participant.title.textColor(Design.color.textInvert)
               //               participant.body.textColor(Design.color.textInvert)

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
