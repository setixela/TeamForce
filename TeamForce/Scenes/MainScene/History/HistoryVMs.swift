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
      setMain {
         $0
            .set_image(Design.icon.avatarPlaceholder)
            .set_size(.square(52))
      } setRight: {
         $0
            .set_padLeft(18)
            .set_alignment(.leading)
            .setMain {
               $0
                  .set_text("Hello")
                  .set_padBottom(10)
                  .set_font(Design.font.body1)
                  .set_alignment(.left)
            } setDown: {
               $0
                  .set_color(Design.color.textInvert)
                  .set_alignment(.left)
                  .set_height(Design.params.cornerRadiusSmall * 2)
                  .set_shadow(Shadow())
                  .set_cornerRadius(Design.params.cornerRadiusSmall)
            }
      } setRight2: {
         $0
            .set_alignment(.trailing)
            .setMain {
               $0
                  .set_font(Design.font.body3)
                  .set_alignment(.right)

            } setDown: {
               $0
                  .set_size(.square(32))
            }
      }
   }
}

