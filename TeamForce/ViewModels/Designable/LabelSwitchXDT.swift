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

import ReactiveWorks

final class SwitcherBox<Down: VMPS, Design: DSP>:
   M<LabelSwitcherXDT<Design>>.D<Down>.Combo, Designable
{
   //
   var labelSwitcher: LabelSwitcherXDT<Design> { models.main }
   var optionModel: Down { models.down }

   override func start() {
      super.start()

      optionModel.hidden(true)
      labelSwitcher.switcher
         .on(\.turnedOn, self) {
            $0.optionModel.hidden(false)
         }
         .on(\.turnedOff, self) {
            $0.optionModel.hidden(true)
         }
   }
}
