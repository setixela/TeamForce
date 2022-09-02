//
//  HistoryVMs.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks

final class HistoryCellModel<Design: DSP>:
   Main<ImageViewModel>.Right<TitleSubtitleY<Design>>.Right2<TitleIconY>.Combo,
   Designable
{
   required init() {
      super.init(isAutoreleaseView: true)

      alignment(.center)
      padding(.init(top: 23, left: 16, bottom: 23, right: 16))
      setAll { icon, nameStatus, summa in
         icon
            .image(Design.icon.avatarPlaceholder)
            .contentMode(.scaleAspectFill)
            .cornerRadius(52.aspected / 2)
            .size(.square(52.aspected))
         nameStatus
            .padLeft(18)
            .alignment(.leading)
            .setAll { username, status in
               username
                  .padBottom(10)
                  .set(Design.state.label.body1)
                  .alignment(.left)
               status
                  .textColor(Design.color.textInvert)
                  .alignment(.left)
                  .height(Design.params.cornerRadiusSmall * 2)
                  .cornerRadius(Design.params.cornerRadiusSmall)
            }
         summa
            .alignment(.trailing)
            .setAll { sumText, cancelButton in
               sumText
                  .set(Design.state.label.body3)
                  .alignment(.right)
               cancelButton
                  .size(.square(1)) // TODO: - change to SVG
                  .hidden(true) // TODO: - change to SVG
            }
      }
   }
}
