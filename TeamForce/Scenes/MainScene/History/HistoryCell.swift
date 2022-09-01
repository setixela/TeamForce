//
//  HistoryVMs.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 18.08.2022.
//

import ReactiveWorks

final class HistoryCellModel<Design: DSP>:
   Combos<SComboMRR<ImageViewModel, TitleSubtitleY<Design>, TitleIconY>>,
   Designable
{
   required init() {
      super.init(isAutoreleaseView: true)

      set_alignment(.center)
      set_padding(.init(top: 23, left: 16, bottom: 23, right: 16))
      setAll { icon, nameStatus, summa in
         icon
            .set_image(Design.icon.avatarPlaceholder)
            .set_contentMode(.scaleAspectFill)
            //.set_url("https://picsum.photos/200")
            .set_cornerRadius(52.aspected/2)
            .set_size(.square(52.aspected))
         nameStatus
            .set_padLeft(18)
            .set_alignment(.leading)
            .setAll { username, status in
               username
                  .set_padBottom(10)
                  .set(Design.state.label.body1)
                  .set_alignment(.left)
               status
                  .set_textColor(Design.color.textInvert)
                  .set_alignment(.left)
                  .set_height(Design.params.cornerRadiusSmall * 2)
                  .set_cornerRadius(Design.params.cornerRadiusSmall)
            }
         summa
            .set_alignment(.trailing)
            .setAll { sumText, cancelButton in
               sumText
                  .set(Design.state.label.body3)
                  .set_alignment(.right)
               cancelButton
                  .set_size(.square(1)) // TODO: - change to SVG
                  .set_hidden(true) // TODO: - change to SVG
            }
      }
   }
}
