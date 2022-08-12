//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleYVM<Design: DesignProtocol>:
   Combos<SComboMD<LabelModel, LabelModel>>,
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
            .set(.color(Design.color.text2))
            .set(.numberOfLines(0))
            .set(.alignment(.center))
            .set(.padUp(Design.Parameters.titleSubtitleOffset))
      }
   }
}
