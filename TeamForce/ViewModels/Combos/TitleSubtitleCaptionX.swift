//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleCaptionX<Design: DesignProtocol>:
   Combos<SComboMRR<LabelModel, LabelModel, LabelModel>>,
   Designable
{

   required init() {
      super.init()
      
      setMain {
         $0
            .set(Design.state.label.title)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      } setRight: {
         $0
            .set(Design.state.label.subtitle)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
            .set(.color(Design.color.textSecondary))
      } setRight2: {
         $0
            .set(Design.state.label.caption)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      }
   }
}
