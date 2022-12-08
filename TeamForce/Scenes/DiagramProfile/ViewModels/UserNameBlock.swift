//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - UserNameBlock

final class UserNameBlock<Design: DSP>: M<LabelModel>.R<LabelModel>.R2<LabelModel>.R3<Spacer>.Combo,
                                        Designable
{
   required init() {
      super.init()

      setAll { name, surname, nickname, _ in
         name
            .set(Design.state.label.headline4)
         surname
            .set(Design.state.label.headline4)
            .textColor(Design.color.textBrand)
         nickname
            .set(Design.state.label.headline4)
      }
   }
}

extension UserNameBlock: StateMachine {
   func setState(_ state: String) {
      models.main.text("Привет, ")
      models.right.text(state)
      models.right2.text("!")
   }
}
