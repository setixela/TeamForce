//
//  ChallengeDetailsInfoCell.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 20.11.2022.
//

import ReactiveWorks

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
