//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleCaptionY<Design: DesignProtocol>:
   Combos<SComboMDD<LabelModel, LabelModel, LabelModel>>,
   Designable
{
   required init() {
      super.init()
      
      setMain {
         $0
            .set(Design.state.label.title)
            .set_numberOfLines(0)
            .set_alignment(.center)
      } setDown: {
         $0
            .set(Design.state.label.subtitle)
            .set_numberOfLines(0)
            .set_alignment(.center)
            .set_padTop(Design.params.titleSubtitleOffset)
            .set_textColor(Design.color.textSecondary)
      } setDown2: {
         $0
            .set(Design.state.label.caption)
            .set_numberOfLines(0)
            .set_alignment(.center)
            .set_padTop(Design.params.titleSubtitleOffset)
      }
   }
}
