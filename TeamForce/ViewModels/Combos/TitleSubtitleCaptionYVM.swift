//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleCaptionYVM<Design: DesignProtocol>:
   Combos<SComboMDD<LabelModel, LabelModel, LabelModel>>,
   Designable
{
   required init() {
      super.init()
      
      setMain {
         $0
            .set(Design.state.label.title)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      } setDown: {
         $0
            .set(Design.state.label.subtitle)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
            .set(.padUp(Design.params.titleSubtitleOffset))
            .set(.color(Design.color.text2))
      } setDown2: {
         $0
            .set(Design.state.label.caption)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
            .set(.padUp(Design.params.titleSubtitleOffset))
      }
   }
}
