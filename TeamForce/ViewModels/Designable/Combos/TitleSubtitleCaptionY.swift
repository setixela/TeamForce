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
            .numberOfLines(0)
            .alignment(.center)
      } setDown: {
         $0
            .set(Design.state.label.subtitle)
            .numberOfLines(0)
            .alignment(.center)
            .padTop(Design.params.titleSubtitleOffset)
            .textColor(Design.color.textSecondary)
      } setDown2: {
         $0
            .set(Design.state.label.caption)
            .numberOfLines(0)
            .alignment(.center)
            .padTop(Design.params.titleSubtitleOffset)
      }
   }
}
