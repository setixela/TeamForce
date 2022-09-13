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

final class SwitcherBox<D: VMPS, Design: DSP>:
   M<LabelSwitcherXDT<Design>>.D<D>.Combo, Designable
{
   //
   var labelSwitcher: LabelSwitcherXDT<Design> { models.main }
   var optionModel: D { models.down }

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
