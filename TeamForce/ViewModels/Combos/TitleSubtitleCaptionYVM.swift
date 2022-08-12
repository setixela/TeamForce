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
            .set(Design.label.state.title)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      } setDown: {
         $0
            .set(Design.label.state.subtitle)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
            .set(.padUp(Design.Params.titleSubtitleOffset))
            .set(.color(Design.color.text2))
      } setDown2: {
         $0
            .set(Design.label.state.caption)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
            .set(.padUp(Design.Params.titleSubtitleOffset))
      }
   }
}
