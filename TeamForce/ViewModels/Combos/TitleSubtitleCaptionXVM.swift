//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 12.08.2022.
//

import ReactiveWorks

class TitleSubtitleCaptionXVM<Design: DesignProtocol>:
   Combos<SComboMRR<LabelModel, LabelModel, LabelModel>>,
   Designable
{
   override func start() {
      setMain {
         $0
            .set(Design.label.state.title)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      } setRight: {
         $0
            .set(Design.label.state.subtitle)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      } setRight2: {
         $0
            .set(Design.label.state.caption)
            .set(.numberOfLines(0))
            .set(.alignment(.center))
      }
   }
}
