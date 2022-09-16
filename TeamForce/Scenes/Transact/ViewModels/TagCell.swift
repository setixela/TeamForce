//
//  TagCell.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 15.09.2022.
//

import ReactiveWorks

final class TagCell<Design: DSP>: IconTitleX, Designable {
   override func start() {
      super.start()

      backColor(Design.color.background)
      label.set(Design.state.label.body1)
   }
}

extension TagCell: StateMachine {
   func setState(_ state: SelectState) {
      switch state {
      case .none:
         icon.borderWidth(0)
         icon.borderColor(Design.color.transparent)
      case .selected:
         icon.borderWidth(2)
         icon.borderColor(Design.color.iconBrand)
      }
   }
}
