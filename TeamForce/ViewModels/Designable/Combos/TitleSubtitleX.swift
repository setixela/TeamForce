//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleX<Design: DesignProtocol>:
   Combos<SComboMR<LabelModel, LabelModel>>,
   Designable
{
   required init() {
      super.init()

      setMain {
         $0
            .set(Design.state.label.title)
            .set_alignment(.center)
      } setRight: {
         $0
            .set(Design.state.label.subtitle)
            .set_alignment(.center)
            .set_textColor(Design.color.textSecondary)
      }
   }
}
