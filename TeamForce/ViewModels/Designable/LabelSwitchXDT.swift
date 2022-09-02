//
//  LabelSwitchXDT.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 23.08.2022.
//

final class LabelSwitcherXDT<Design: DSP>: LabelSwitcherX {
   override func start() {
      super.start()

      padding(Design.params.contentVerticalPadding)
      label
         .set(Design.state.label.body1)
         .backColor(Design.color.background)
   }
}
