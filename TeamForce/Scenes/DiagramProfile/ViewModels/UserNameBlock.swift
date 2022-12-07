//
//  File.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 08.12.2022.
//

import ReactiveWorks

// MARK: - UserNameBlock

final class UserNameBlock<Design: DSP>: M<LabelModel>.R<LabelModel>.LD<LabelModel>.Combo,
                                        Designable
{
   required init() {
      super.init()

      setAll { name, surname, nickname in
         name
            .set(Design.state.label.headline4)
         surname
            .set(Design.state.label.headline4)
            .textColor(Design.color.textBrand)
         nickname
            .set(Design.state.label.subtitle)
      }

      alignment(.leading)
   }
}

extension UserNameBlock: StateMachine {
   func setState(_ state: (name: String, surname: String, nickname: String)) {
      models.main.text(state.name)
      models.right.text(" " + state.surname)
      models.leftDown.text("@" + state.nickname)
   }
}
