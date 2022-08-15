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
            .setNumberOfLines(0)
            .setAlignment(.center)
      } setDown: {
         $0
            .set(Design.state.label.subtitle)
            .setNumberOfLines(0)
            .setAlignment(.center)
            .setPadTop(Design.params.titleSubtitleOffset)
            .setColor(Design.color.textSecondary)
      } setDown2: {
         $0
            .set(Design.state.label.caption)
            .setNumberOfLines(0)
            .setAlignment(.center)
            .setPadTop(Design.params.titleSubtitleOffset)
      }
   }
}
