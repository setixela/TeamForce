//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleXVM<Design: DesignProtocol>:
   Combos<SComboMR<LabelModel, LabelModel>>,
   Designable
{
   override func start() {
      setMain {
         $0
            .set(Design.label.state.title)
            .set(.alignment(.center))
      } setRight: {
         $0
            .set(Design.label.state.subtitle)
            .set(.alignment(.center))
      }
   }
}
